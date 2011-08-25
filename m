Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751562Ab1HYP4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:56:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751018Ab1HYP4F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:56:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
References: <20110825070335.3095B3BC183@tippex.mynet.homeunix.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Aug 2011 08:55:12 -0700
Message-ID: <CA+55aFzndqkSC1z3==HqUGC8hP=pw62ro3CWYtovk95_cYAKsA@mail.gmail.com>
Subject: Re: mtrr failure, 3.1-rc1
To: Anders Eriksson <aeriksson@fastmail.fm>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm. Some of those commits are marked for stable too.

I'm adding appropriate parties to the discussion (authors and
sign-offs from the five commits that that merge brings in), but it
would also be great if you could bisect exactly which commit broke for
you. You can make it quick by just doing

  git bisect start
  git bisect bad dc43d9fa73d82083656fb9c02f4823bcdcfb9f91
  git bisect good dc43d9fa73d82083656fb9c02f4823bcdcfb9f91^

and it should take just a couple of tests. I *assume* it's the
stop_machine changes by Tejun &co, but who knows..

Anders, is this a single-CPU system?

                            Linus

On Thu, Aug 25, 2011 at 12:03 AM, Anders Eriksson <aeriksson@fastmail.fm> wrote:
>
> My old P-II has 640MB ram, but the bios only sets up WC for the first 512, so i
> add this early in the boot process:
> echo "base=0x20000000 size=0x8000000 type=write-back" > /proc/mtrr
>
> For reasons I have forgot I also have to add 'disable_mtrr_check' to the
> command line. Works great.
>
> As of merge dc43d9fa73d82083656fb9c02f4823bcdcfb9f91 This no longer works.
> Adding that line to /proc/mtrr no longer has any effect (cat /proc/mtrr shows
> only the reg00 entry).
>
> Reverting that merge on top of rc3 brings things back to normal and /proc/mtrr
> shows:
> reg00: base=0x000000000 (    0MB), size=  512MB, count=1: write-back
> reg01: base=0x048000000 ( 1152MB), size=  128MB, count=1: write-combining
> reg02: base=0x020000000 (  512MB), size=  128MB, count=2: write-back
>
> Any ideas how to track this down futher? Would be good to get it fixed for 3.1
>
> -Anders
>
>
>
