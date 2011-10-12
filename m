Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1JLMqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:46:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50158 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1JLMqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:46:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
Date: Wed, 12 Oct 2011 14:46:49 +0200
Message-ID: <CA+O4pCKGJO_p9J-bTvTGSoAh3PLkwwOwRM-9p+9nuRpPnZHdDw@mail.gmail.com>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 2:36 PM, Markus Rechberger
<mrechberger@gmail.com> wrote:
> We have 2 products which can perform better with increased Bulk transfers
>
> Device No. 1:
> According to the hardware spec of on of our product
> Available Bulk Transfer Size are:
> - 188 * n bytes, where n = 1 ~ 256.
>
> Although we can drive that one with 15K as well when setting the HW
> register down to it.
>
> Device No. 2
> only creates jitter video with Bulk transfer sizes which are below
> 24064 bytes, no such chipfeature is available
> to decrease the bulk transfer size.
> http://sundtek.de/images/dtvjitter2.jpg
> with transfer size of 24064:
> http://sundtek.de/images/gooddata.jpg
>
> The patch takes the features of Device No. 1 into account allowing a
> maximum buffer of 48128 bytes.
>
> Those issues have been evaluated with MacOSX and a customized patched
> Linux version.
> Device No. 2 also corrupts on MacOSX with too small packet sizes,
> Windows and Mac are using 24064 bytes.
>
> Default Bulk Transfersize of device No. 1 is around 1-2k which leads
> to very high cpu usage, updating it to 15k lowers that one.
>


Signed-off-by: Markus Rechberger <mrechberger@gmail.com>
