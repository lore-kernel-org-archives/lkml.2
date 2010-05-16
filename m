Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab0EPU0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 16:26:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:42493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0EPU0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 16:26:46 -0400
Date: Sun, 16 May 2010 13:29:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100516132933.617d1544@infradead.org>
In-Reply-To: <b7b4f345-944c-4cbc-b98a-700f915183b9@default>
References: <1273887635-27610-1-git-send-email-venki@google.com>
	<87tyq9mqrz.fsf@basil.nowhere.org>
	<35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
	<20100515121424.38f5b389@infradead.org>
	<e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>
	<20100515224305.17a04022@infradead.org
 alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>
	<b7b4f345-944c-4cbc-b98a-700f915183b9@default>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 May 2010 09:42:40 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > From: Thomas Gleixner [mailto:tglx@linutronix.de]
> > Nah, there are systems which will have it set to 1:
> > Dig out your good old Pentium-I box and enjoy.
> 
> Hot stove syndrome again?  Are you truly saying that there
> are NO single-socket multi-core systems that don't have
> stupid firmware (SMI and/or BIOS)? 

there are no systems *where we can know* this.
Some of the stupid SMI only triggers on higher temperature situations
etc. Impossible to know upfront.


> If things are this bad, why on earth would the kernel itself
> EVER use TSC even as its own internal clocksource? 

Why do you think we do extensive and continuous validation of the tsc
(and soon, continuous recalibration)


> But that doesn't mean the vast majority of latest generation
> single-socket systems can't set "tsc_reliable" to 1.  Or that
> the kernel is responsible for detecting and/or correcting
> every system with buggy firmware.

sadly this also shows up on single socket systems... much more than we
like.

This is why I really really hate having apps run tsc directly.
A VDSO call at least gives the kernel the option to ensure
correctness... even if it starts out fast and goes slow suddenly after
3 weeks when the AC in the datacenter got maintenance for an hour.





-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
