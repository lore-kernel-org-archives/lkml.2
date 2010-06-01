Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab0FAThG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:37:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37541 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0FAThE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:37:04 -0400
Date: Tue, 1 Jun 2010 21:36:59 +0200
From: Andi Kleen <andi@firstfloor.org>
To: john cooper <john.cooper@third-harmonic.com>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, npiggin@suse.de,
       tglx@linutronix.de, mtosatti@redhat.com,
       john cooper <john.cooper@redhat.com>
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100601193659.GC11880@basil.fritz.box>
References: <20100601093515.GH24302@redhat.com> <87sk56ycka.fsf@basil.nowhere.org> <20100601162414.GA6191@redhat.com> <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com> <4C05493F.1040107@third-harmonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C05493F.1040107@third-harmonic.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Collecting the contention/usage statistics on a per spinlock
> basis seems complex.  I believe a practical approximation
> to this are adaptive mutexes where upon hitting a spin
> time threshold, punt and let the scheduler reconcile fairness.

That would probably work, except: how do you get the
adaptive spinlock into a paravirt op without slowing
down a standard kernel?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
