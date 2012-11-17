Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab2KQIkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 03:40:09 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48471 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab2KQIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 03:40:08 -0500
MIME-Version: 1.0
In-Reply-To: <CAGjg+kFUp_bACC-nze9og7+2XCXoURRunoTi4OY9-NgepU39mA@mail.gmail.com>
References: <1353083121-4560-1-git-send-email-mingo@kernel.org>
	<CAGjg+kFUp_bACC-nze9og7+2XCXoURRunoTi4OY9-NgepU39mA@mail.gmail.com>
Date: Sat, 17 Nov 2012 16:40:07 +0800
Message-ID: <CAGjg+kFD4r-J2Eq5tgTdCmktDLwDLaoteqw1Zc5vCnX6Rxb+DA@mail.gmail.com>
Subject: Re: [PATCH 00/19] latest numa/base patches
From: Alex Shi <lkml.alex@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hughd@google.com>,
        Alex Shi <alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 4:35 PM, Alex Shi <lkml.alex@gmail.com> wrote:
> Just find imbalance issue on the patchset.
>
> I write a one line program:
> int main ()
> {
>         int i;
>         for (i=0; i< 1; )
>                 __asm__ __volatile__ ("nop");
> }
> it was compiled with name pl and start it on my 2 socket * 4 cores *
> HT NUMA machine:
> the cpu domain top like this:
> domain 0: span 4,12 level SIBLING
>   groups: 4 (cpu_power = 589) 12 (cpu_power = 589)
>   domain 1: span 0,2,4,6,8,10,12,14 level MC
>    groups: 4,12 (cpu_power = 1178) 6,14 (cpu_power = 1178) 0,8
> (cpu_power = 1178) 2,10 (cpu_power = 1178)
>    domain 2: span 0,2,4,6,8,10,12,14 level CPU
>     groups: 0,2,4,6,8,10,12,14 (cpu_power = 4712)
>     domain 3: span 0-15 level NUMA
>      groups: 0,2,4,6,8,10,12,14 (cpu_power = 4712) 1,3,5,7,9,11,13,15
> (cpu_power = 4712)
>
> $for ((i=0; i< I; i++)); do ./pl & done
> when I = 2, they are running on cpu 0,12
> I = 4, they are running on cpu 0,9,12,14
> I = 8, they are running on cpu 0,4,9,10,11,12,13,14
>

Ops, it was tested on latest V15 tip/master tree, head is
a7b7a8ad4476bb641c8455a4e0d7d0fd3eb86f90
not on this series.
Sorry.
