Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab1LFPOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 10:14:05 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:60121 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753540Ab1LFPOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 10:14:04 -0500
Date: Tue, 6 Dec 2011 10:13:45 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, ben@decadent.org.uk,
        mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, bug: Exclude
 TAINT_FIRMWARE_WORKAROUND from disabling lockdep
Message-ID: <20111206151345.GA22353@elliptictech.com>
References: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-06 01:38 -0800, tip-bot for Peter Zijlstra wrote:
> Commit-ID:  df754e6af2f237a6c020c0daff55a1a609338e31
> Gitweb:     http://git.kernel.org/tip/df754e6af2f237a6c020c0daff55a1a609338e31
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Mon, 14 Nov 2011 13:13:49 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 6 Dec 2011 08:16:47 +0100
> 
> lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
> 
> It's unlikely that TAINT_FIRMWARE_WORKAROUND causes false
> lockdep messages, so do not disable lockdep in that case.
> We still want to keep lockdep disabled in the
> TAINT_OOT_MODULE case:
> 
>   - bin-only modules can cause various instabilities in
>     their and in unrelated kernel code
> 
>   - they are impossible to debug for kernel developers
> 
>   - they also typically do not have the copyright license
>     permission to link to the GPL-ed lockdep code.

This is all bogus.  We have a proprietary module taint for the above.
Out of tree does not mean "bin-only", "non-GPL" or anything else like
that.  If the intent is to tell out of tree, GPL module developers to
fuck off and die, then just go all the way and delete support for out
of tree modules from Kbuild.  May as well go further and just prevent
the kernel from loading such modules outright, too.

Don't gag developers by arbitrarily disabling kernel debugging
functionality: functionality that they can use to debug their
*GPL* modules.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
