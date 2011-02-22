Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab1BVUBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:01:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58810 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1BVUBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SL+PN8/Y+8Jc6ji/INNs1SNZ2SlWIgMvrrcNs/zw/s5Z5J1TieJsukqB+g4G5+Vkv6
         xr4PCfC9GlaBZuBcmDCz8d9E328HCPdiyI0jDEL2RIWCVaD3K29I8389mpH6OJXthbMv
         m/PsmW6mCFDqiWVmOC3oJzf1odX/tUzc2t4ro=
Date: Tue, 22 Feb 2011 11:52:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "pantherchen@versanet.de" <pantherchen@versanet.de>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
Message-ID: <20110222195257.GA13256@core.coreip.homeip.net>
References: <4D62CE9C.7090806@versanet.de>
 <20110222081752.GP31267@htj.dyndns.org>
 <20110222085223.GC11681@core.coreip.homeip.net>
 <20110222090255.GR31267@htj.dyndns.org>
 <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com>
 <4D63D062.3040404@versanet.de>
 <20110222172254.GA13114@core.coreip.homeip.net>
 <20110222175955.GA27991@core.coreip.homeip.net>
 <4D640F67.3040109@versanet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D640F67.3040109@versanet.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 08:32:55PM +0100, pantherchen@versanet.de wrote:
> On 02/22/2011 06:59 PM, Dmitry Torokhov wrote:
> >On Tue, Feb 22, 2011 at 09:22:54AM -0800, Dmitry Torokhov wrote:
> >>Just to confirm, if you revert commit
> >>
> >>	8ee294cd9def0004887da7f44b80563493b0a097
> >>
> >>from 2.6.38-rc6, does this restore boot time?
> 
> Yes, it's booting fine with that commit reverted.
> 
> >And if that indeed fixes the issue I wonder if the reason for the stall
> >is that we trip on flush_scheduled_work() somewhere. If you could stick
> >dump_stack() into flush_scheduled_work() that might give us some clues.
> 
> I wasn't sure where to put the dump_stack() call, so I placed one
> before and one after the flush_workqueue() call.
> 
> Here's the part that turned up in dmesg: http://paste.ubuntu.com/570729/
> 

Ewww... tty/ldisc...

Does it help if you change drivers/input/serio/serio.c::serio_queue_event()
from calling

	schedule_work(&serio_event_work);

to call

	queue_work(system_long_wq, &serio_event_work);

?

Thanks.

-- 
Dmitry
