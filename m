Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab0DKWAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 18:00:31 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58558 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0DKWA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 18:00:29 -0400
X-Greylist: delayed 474 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Apr 2010 18:00:29 EDT
X-AuthUser: davidel@xmailserver.org
Date: Sun, 11 Apr 2010 14:52:12 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andi Kleen <andi@firstfloor.org>
cc: Frantisek Rysanek <Frantisek.Rysanek@post.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: setitimer vs. threads: SIGALRM returned to which thread? (process
 master or individual child)
In-Reply-To: <87d3y5btdk.fsf@basil.nowhere.org>
Message-ID: <alpine.DEB.2.00.1004111449040.25644@makko.or.mcafeemobile.com>
References: <4BBFA0C6.2610.2C4FFE@Frantisek.Rysanek.post.cz> <87d3y5btdk.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Apr 2010, Andi Kleen wrote:

> "Frantisek Rysanek" <Frantisek.Rysanek@post.cz> writes:
> 
> > Yes, it used to be quite a relief to have Linux do the management of 
> > timers for me. Now I have two options to choose from:
> > 1) write my own "timer queueing" (timekeeping) code to order the 
> > timers for me in the master thread
> > 2) find another function, similar to setitimer(), that would function 
> > the way setitimer() used to work in the old days...
> 
> POSIX timers (timer_create et.al.) allow specifying the signal.
> 
> So if you use custom RT signals for each threads and block them in the
> threads you don't want them it should work. This would limit the
> maximum number of threads though because there's only a limited
> range of RT signals.
> 
> There are probably other ways to do this too, e.g. with some clever
> use of timerfd_create in recent kernels.

Definitely timerfd allows you to handle the timer event wherever you 
like, independently from signals.  Much much simpler routing.
But if you need to be compatible with multiple unixes, of even older linux 
kernel, you are out of luck with timerfd.


- Davide


