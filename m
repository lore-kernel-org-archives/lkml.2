Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806Ab2B1OVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:21:09 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59228 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2B1OVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:21:07 -0500
Message-ID: <1330438853.11248.90.camel@twins>
Subject: Re: lockdep: Warning & NULL ptr deref
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 15:20:53 +0100
In-Reply-To: <CA+1xoqfMad+s4-E-Nn29m3=bVASEkH38ZNvWg2vY99ZizdAT3Q@mail.gmail.com>
References: <1330442692.3719.7.camel@lappy>
	 <1330435782.11248.89.camel@twins>
	 <CA+1xoqfMad+s4-E-Nn29m3=bVASEkH38ZNvWg2vY99ZizdAT3Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 16:19 +0200, Sasha Levin wrote:
> On Tue, Feb 28, 2012 at 3:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2012-02-28 at 10:24 -0500, Sasha Levin wrote:
> >>
> >> I'll send some patches to prevent the NULL deref itself which happens
> >> since a chunk of the code in lockdep.c assumed hlock_class() can't
> >> return NULL.
> >>
> > There's tons of code actually assuming that..
> >
> >> This won't fix the actual problem though, I'm not sure exactly how a
> >> held lock wouldn't have a class initialized to it.
> >
> > static inline struct lock_class *hlock_class(struct held_lock *hlock)
> > {
> >        if (!hlock->class_idx) {
> >                /*
> >                 * Someone passed in garbage, we give up.
> >                 */
> >                DEBUG_LOCKS_WARN_ON(1);
> >                return NULL;
> >        }
> >        return lock_classes + hlock->class_idx - 1;
> > }
> >
> > Typically that translates to severe memory corruption.
> 
> I can also reproduce it easily by triggering sysrq once or twice after
> trinity has stopped.

What's trinity ?
