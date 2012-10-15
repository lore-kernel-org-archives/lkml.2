Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab2JOMGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:06:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2JOMGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:06:38 -0400
MIME-Version: 1.0
In-Reply-To: <2564763.3cNFlv543H@linux-lqwf.site>
References: <1350278059-14904-1-git-send-email-ming.lei@canonical.com>
	<1350278059-14904-4-git-send-email-ming.lei@canonical.com>
	<2564763.3cNFlv543H@linux-lqwf.site>
Date: Mon, 15 Oct 2012 20:06:36 +0800
Message-ID: <CACVXFVPi=fq1NP-nuWQi34xTpGgWbaceW1Hbzcq38RqQMF_T-w@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] USB: forbid memory allocation with I/O during bus
 reset if storage interface exits
From: Ming Lei <ming.lei@canonical.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 5:34 PM, Oliver Neukum <oneukum@suse.de> wrote:
>
> I think limiting this to devices which have a storage device is not
> productive. What if you are using iSCSI or nbd? In the long run

You mean other non-mass storage or non-uas usb interfaces may
be involved in iSCSI or nbd? If not, the patch should be OK.
If yes, could you list them?

> we will see busses attached to busses and as soon as the daughter
> bus is hotpluggable you are thwarted anyway. Just do it unconditionally.

IMO, doing it unconditionally is not good because big chunk buffer
is often allocated in probe() path.

Thanks,
--
Ming Lei
