Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059Ab0DVTdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:33:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33085 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab0DVTdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:33:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wH4UMpSQdLFCRekfuGK1JVpPcK9yWWkTq5uV7rG4lYr52EhShytkHY9Umhpd7CO10L
         vk74gU8+lVKAqlfQi8M2gQ5zSNKqPBdXEfWzAI7AeVgf7UDB0eAkCKxNK+yZVXjGIRAU
         395Gp4cyE+cUOJ1qwjhyYashOQHafZ6nOSuv4=
MIME-Version: 1.0
In-Reply-To: <1271953686.1776.372.camel@laptop>
References: <s2uc5b2c05b1004191348p517c8ac4z32104ea91dd1ca67@mail.gmail.com>
	 <x2mc5b2c05b1004211224s7825933dh531f2ed030610e9e@mail.gmail.com>
	 <1271879833.1776.186.camel@laptop>
	 <s2tc5b2c05b1004211338y814bc3b2o547a6eecdf64ca7f@mail.gmail.com>
	 <1271883496.1776.263.camel@laptop>
	 <1271942430.10448.196.camel@gandalf.stny.rr.com>
	 <x2hc5b2c05b1004220650w53919f62hf3daedb822755bf4@mail.gmail.com>
	 <1271944622.1776.349.camel@laptop>
	 <k2gc5b2c05b1004220840z59f9417fy723a36a6fe9924dc@mail.gmail.com>
	 <1271953686.1776.372.camel@laptop>
Date: Thu, 22 Apr 2010 21:33:06 +0200
Message-ID: <t2uc5b2c05b1004221233z4f071c31ia9b2be2dde72cf96@mail.gmail.com>
Subject: Re: Considerations on sched APIs under RT patch
From: Primiano Tucci <p.tucci@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       tglx <tglx@linutronix.de>, Bjoern Brandenburg <bbb@email.unc.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
It is not in my intents to start a flame, but, as you pointed out
yourself, EDF is not so common, particularly in commercial RTOSes as
you stated (and xnu, indeed, does not fall into this category).

It is not surprisingly that the citation you found was from Mr
Brandenburg and Mr. Anderson from North Carolina University,
incidentally I had a copy of their paper (On the Implementation of
Global RT Schedulers) at the time of reading your message. I think
they're are among the few that concretely and deeply investigated on
G-EDF.
As you could read by Brandenburg and Anderson, there isn't a
standard/reference implementation of Global EDF, but a alot of
"variants" are possible (e.g., event-driven / tick driven promotion,
dedicated/global interrupt handling,  typology of data structures and
locking methods ...).
My intent is not to make a form of top ten best kernel award, all we
are trying to do is investigating on the various facilities offered by
the RT operating systems in order to determine how much we can rely on
them.

>> It is how it is implemented now, and how it works under VXWorks!
>
> But that does not, and can not, provide proper isolation and bandwidth
> guarantees since there could be runnable tasks outside the scope of the
> middleware.

Actually our implementation in VxWorks is based on kernel space tasks
that have the maximum priority on the system, even greater of VxWorks
system tasks (that have been shifted down after long and fruitful
support discussions with windriver) therefore no task (except from
interrupt service routines that are accurately weighted under VxWorks)
can alter our middleware. Actually it is controlling real world (yet
not production stage) manufacturing systems, and it is a bit more than
just a play-game.

We are trying to study and understand if, and how, analogous things
can be done on other Real Time Operating Systems.
We choiced posix threads as a start point on linux kernel to verify
the feasibility of the same approach, without intervening too deep on
the kernel.

Thanks again for your interventions!

--
 Primiano Tucci
 http://www.primianotucci.com
