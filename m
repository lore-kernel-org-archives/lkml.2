Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757096Ab2C0X0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 19:26:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756825Ab2C0X0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 19:26:35 -0400
Date: Tue, 27 Mar 2012 16:26:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] floppy: revert floppy disable halt warning
Message-Id: <20120327162633.654c8d7e.akpm@linux-foundation.org>
In-Reply-To: <20120311093853.04f049c2@s6510.linuxnetplumber.net>
References: <20120311093853.04f049c2@s6510.linuxnetplumber.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc some x86 greybeards)

On Sun, 11 Mar 2012 09:38:53 -0700
Stephen Hemminger <shemminger@vyatta.com> wrote:

> Remove the stupid floppy disable halt warning. It is meaningless since
> the API is local to floppy driver.  Our boot scripts check for the
> floppy drive, and this causes the warning to trigger every time. This
> confuses support, breaks automated tests that look for backtraces on
> boot,  and adds no value.  
> 
> The message is being displayed to the wrong audience, it looks like it
> was intended as a compromise of a long discussion on LKML about
> supporting older x86 hardware; but users don't know or understand what
> it is saying.
> 
> If you want to change halt handling then just fix
> the floppy driver, don't whine about it.
> 
> ...
> 
> --- a/drivers/block/floppy.c	2012-03-11 09:27:52.866459327 -0700
> +++ b/drivers/block/floppy.c	2012-03-11 09:28:29.286579201 -0700
> @@ -1037,7 +1037,6 @@ static void floppy_disable_hlt(void)
>  {
>  	unsigned long flags;
>  
> -	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
>  	spin_lock_irqsave(&floppy_hlt_lock, flags);
>  	if (!hlt_disabled) {
>  		hlt_disabled = 1;

It would have been nice to have provided a pointer to this "long
discussion on LKML".  I tried for a while, then gave up.

In my search I came across
http://lkml.indiana.edu/hypermail/linux/kernel/1104.0/00461.html which
does indeed remove all the disable_hlt() code as well as the warning
and the feature-removal-schedule.txt record.  Why didn't we merge that?
Why shouldn't we merge that now?


