Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab1AGPie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:38:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62731 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab1AGPid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:38:33 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=u1gODonWejgA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Njwlpt66t2i8tteSDckA:9 a=FM35fwDIjvclX0j2PZdCkeov8FAA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: likely unlikely annotation (spinlock status)
From: Steven Rostedt <rostedt@goodmis.org>
To: manikanta <manikanta4u@gmail.com>
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <AANLkTim7vD_j-80H-r4gaAmxxb==fDAvZ9GFYx682KGZ@mail.gmail.com>
References: <AANLkTim7vD_j-80H-r4gaAmxxb==fDAvZ9GFYx682KGZ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 07 Jan 2011 10:38:29 -0500
Message-ID: <1294414709.26623.215.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-07 at 15:57 +0530, manikanta wrote:
> Hi Rostedt,
>  
> Problem:    
> Likely and unlikely annotation branch summary is showing
> status for spinlocks(below is the result of enabling
> CONFIG_PROFILE_ANNOTATED_BRANCHES).
> Is it right(eventhough at line no 6753 i can see spin_unlock(lock))???

Your spin_unlock is probably a macro which contains an "if (likely())"
in it. If this is the case then it would definitely show a location of
the spin lock, because that spinlock is nothing more than an if
statement to gcc.

>  
> 0       19 100 __cond_resched_lock            sched.c
> 6753
> 0        0   X   dsp_event                             audio_xwb.c
> 355
>  
> I am seeing the same results for my drivers also i.e. where we have
> used spinlocks.
> It is showing the spinlocks results.At line number 355 there is a
> spinlock call in file
> audio_xwb.c.
>  
> Is it right to show spinlock status instead of likely and unlikely
> notations???

Yes, if the spinlocks are macros with likely/unlikely annotations.

>  
> Setup:Android + mach-msm

Unfortunately, I don't have this setup to look at it.

-- Steve



