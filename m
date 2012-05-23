Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579Ab2EWUKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:10:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:56892 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab2EWUKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:10:09 -0400
Message-ID: <4FBD4402.7060509@linux.vnet.ibm.com>
Date: Wed, 23 May 2012 15:09:38 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 2/2 v2] zram: clean up handle
References: <1337737402-16543-1-git-send-email-minchan@kernel.org> <1337737402-16543-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1337737402-16543-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052320-9360-0000-0000-0000069FAB8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 08:43 PM, Minchan Kim wrote:

> zram's handle variable can store handle of zsmalloc in case of
> compressing efficiently. Otherwise, it stores point of page descriptor.
> This patch clean up the mess by union struct.
> 
> changelog
>   * from v1
> 	- none(new add in v2)
> 
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
> Signed-off-by: Minchan Kim <minchan@kernel.org>


Not sure if the BUILD_BUG is completely needed since it's pretty well
assumed that sizeof(unsigned long) == sizeof(void *) but it does provide
some safety is someone tries to change the type of handle.

Acked-by: <sjenning@linux.vnet.ibm.com>

Thanks,
Seth

