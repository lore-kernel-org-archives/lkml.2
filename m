Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2DZHiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 03:38:09 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:39959 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751073Ab2DZHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 03:38:08 -0400
Date: Thu, 26 Apr 2012 09:13:39 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        thomas.mingarelli@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, dzickus@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] watchdog, hpwdt: Remove priority option for NMI callback
Message-ID: <20120426071339.GI6553@spo001.leaseweb.com>
References: <1333051877-15755-2-git-send-email-dzickus@redhat.com> <tip-09ee10143658cd021d879ead61ead72a196302b6@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-09ee10143658cd021d879ead61ead72a196302b6@git.kernel.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> Commit-ID:  09ee10143658cd021d879ead61ead72a196302b6
> Gitweb:     http://git.kernel.org/tip/09ee10143658cd021d879ead61ead72a196302b6
> Author:     Don Zickus <dzickus@redhat.com>
> AuthorDate: Thu, 29 Mar 2012 16:11:15 -0400
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 25 Apr 2012 12:43:33 +0200
> 
> watchdog, hpwdt: Remove priority option for NMI callback
> 
> The NMI_UNKNOWN bucket only allows for one function to register
> to it. The reason for that is because only functions which can
> not determine if the NMI belongs to them or not should register
> and would like to assume/swallow any NMI they see.
> 
> As a result it doesn't make sense to let more than one function
> like this register.  In fact, letting a second function fail
> allows us to know that more than one function is going to
> swallow NMIs on the current system. This is better than silently
> being ignored.
> 
> Therefore hpwdt's priority mechanism doesn't make sense any
> more.  They will be always first on the NMI_UNKNOWN queue, if
> they register.
> 
> Removing this parameter cleans up the code and simplifies things
> for the next patch which changes how nmis are registered.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> Cc: Thomas Mingarelli <thomas.mingarelli@hp.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Link: http://lkml.kernel.org/r/1333051877-15755-2-git-send-email-dzickus@redhat.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

This is the feedback I have from Tom which he discussed with Don:
> I don't like this patch because the Virtual NMI button doesn't come through the pretimeout routine. It is taken by the
system as an IOCK NMI error and no log messages in our IML.
> Our BIOS is not able to source the NMI.

And since then it became quiet. Imho: this needs more discussion...

Kind regards,
Wim.

