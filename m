Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab1CaDJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 23:09:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755362Ab1CaDJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 23:09:25 -0400
Date: Wed, 30 Mar 2011 23:09:18 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331030917.GB26057@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 09:22:25PM -0700, Linus Torvalds wrote:
 > On Mon, Mar 28, 2011 at 9:09 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > I ran perf top, and got this ..
 > >
 > >  BUG: unable to handle kernel paging request at fffffffffffffff3
 > 
 > Should be fixed by commit 76597cd31470.
 > 
 > Except that was already committed yesterday. When did you pull?

It did fix it, I must have missed that commit.

But rerunning the same tests on current head (6aba74f2791287ec407e0f92487a725a25908067)
I can still reproduce the problem where kworker threads go nutso
when the machine should be completely idle.

top shows two kworker threads constantly at >80% cpu.

I can now profile it with perf though, so I'll dig deeper.
I need to try a build with slab debug etc turned off, just to be sure that
isn't throwing things into a spin.

	Dave

