Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1FCJQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:16:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:37428 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab1FCJP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:15:59 -0400
Subject: Re: [tip:sched/locking] sched: Add p->pi_lock to task_rq_lock()
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arne Jansen <lists@die-jansens.de>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, npiggin@kernel.dk,
        akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
References: <20110405152729.232781355@chello.nl>
	 <tip-0122ec5b02f766c355b3168df53a6c038a24fa0d@git.kernel.org>
	 <4DE64596.5010006@die-jansens.de> <1306946120.2497.606.camel@laptop>
	 <4DE674EB.1000200@die-jansens.de> <1306951751.2497.626.camel@laptop>
	 <1306953870.2497.627.camel@laptop> <4DE6936F.7090700@die-jansens.de>
	 <BANLkTimXXR1mJDtdCsbXF410sd3irFSitQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Jun 2011 11:15:35 +0200
Message-ID: <1307092535.2353.2973.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 06:09 +0900, Linus Torvalds wrote:
> Boot-time hang - maybe due to the mis-merge that re-introduced the
> infinite media change signals for ide-cd?
> 
> I just pushed out a fix, it may not have mirrored out yet.
> 
> I dunno. Worth checking out before spending a lot of time bisecting.

Right, so that wasn't it. I haven't done a full bisect yet because I
noticed it died on a usb suspend line every single time and that machine
only had a single usb device, a memory stick, in it. So I simply pulled
the stick and voila it booted. So something is screwy with usb suspend
or something.

This of course means that I'm now completely unable to reproduce the
issue at hand :/

Maybe if I try another box..

Anyway, Arne, how long did you wait before power cycling the box? The
NMI watchdog should trigger in about a minute or so if it will trigger
at all (its enabled in your config).


