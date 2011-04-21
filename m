Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab1DUQiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:38:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:38230 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab1DUQiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:38:13 -0400
Subject: Re: [RFC][PATCH 00/18] Increase resolution of load weights
From: Peter Zijlstra <peterz@infradead.org>
To: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <1303332697-16426-1-git-send-email-ncrao@google.com>
References: <1303332697-16426-1-git-send-email-ncrao@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 18:40:52 +0200
Message-ID: <1303404052.2035.155.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-20 at 13:51 -0700, Nikhil Rao wrote:
> 
> I would like to get some feedback on the direction of this patchset. Please let
> me know if there are alternative ways of doing this, and I'll be happy to
> explore them as well.
> 
> The patchset applies cleanly to v2.6.39-rc4. It compiles for i386 and boots on
> x86_64. Beyond the basic checks, it has not been well tested yet.
> 
> Major TODOs:
> - Detect overflow in update shares calculations (time * load), and set load_avg
>   to maximum possible value (~0ULL).
> - tg->task_weight uses an atomic which needs to be updates to 64-bit on 32-bit
>   machines. Might need to add a lock to protect this instead of atomic ops.
> - Check wake-affine math and effective load calculations for overflows.
> - Needs more testing and need to ensure fairness/balancing is not broken.

The code looks fairly ok and I can't fault the TODOs ;-)

I guess getting some measurements on the performance penalty on 32bit
would be nice -- if only to know about how bad it is.

And while its not perfect by a long stretch (we can still blow the whole
lot by creating a deep enough hierarchy) it should be much better.. the
only advantage of going with a full on wrapper solution would be that
plugging in an arbitrary precision type would be simple ;-)

