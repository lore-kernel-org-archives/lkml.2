Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0FDLuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 07:50:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab0FDLuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 07:50:09 -0400
Date: Fri, 4 Jun 2010 07:51:48 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: wait_even_interruptible_timeout(), signal, spin_lock() = system
 hang
Message-ID: <20100604075148.5bcd7c8d@corrin.poochiereds.net>
In-Reply-To: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
References: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 11:44:46 -0500
Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:

> After this sequence of calls, system hangs (smp, x86 box based with
> .34 kernel), can ping only.
> I have not been able to break in with Alt Sysrq t, working on that
> 
>         rc = wait_event_interruptible_timeout(ses->server->response_q,
>                         (midQ->midState != MID_REQUEST_SUBMITTED), timeout);
>         if (rc < 0) {
>                 cFYI(1, ("command 0x%x interrupted", midQ->command));
>                 return -1;
>         }
> 
> and when function that invoking function after coming out with ERESTARTSYS
> (I kill the command with Ctrl C) calls
>  spin_lock(&GlobalMid_Lock);
> 
> system hangs.  If I sleep before return -1 (e.g. msleep(1), no hang)
> 

Sounds like a race of some sort, but could also be that msleep() is
doing something (perhaps relating to the pending signal) that prevents
the hang. Without some sort of clue as to what the box is hung on at
the time there is no way to know.

> I do not have to use wait_event_interruptible_timeout and no such problems with
> wait_event_timeout, it is only when signal/interrupt is involved, I
> run into this problem
> 
> Any pointers/ideas what could be happening, would be really really appreciated.
> 

No idea right offhand. I'd suggest getting a core or sysrq data and see
what it's doing.

-- 
Jeff Layton <jlayton@redhat.com>
