Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab1BQTMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:12:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543Ab1BQTMl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:12:41 -0500
MIME-Version: 1.0
In-Reply-To: <m1pqqqfpzh.fsf@fess.ebiederm.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz> <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
 <20110217090910.GA3781@tiehlicka.suse.cz> <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 11:11:51 -0800
Message-ID: <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 10:57 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> fedora 14
> ext4 on all filesystems

Your dmesg snippets had ext3 mentioned, though:

  <6>EXT3-fs (sda1): recovery required on readonly filesystem
  <6>EXT3-fs (sda1): write access will be enabled during recovery
  <6>EXT3-fs: barriers not enabled
  ..
  <6>EXT3-fs (sda1): recovery complete
  <6>EXT3-fs (sda1): mounted filesystem with ordered data mode
  <6>dracut: Mounted root filesystem /dev/sda1

not that I see that it should matter, but there's been some bigger
ext3 changes too (like the batched discard).

I don't really think ext3 is the issue, though.

> I was about to say this happens with DEBUG_PAGEALLOC enabled but it
> appears that options keeps eluding my fingers when I have a few minutes
> to play with it.  Perhaps this time will be the charm.

Please do. You seem to be much better at triggering it than anybody
else. And do the DEBUG_LIST and DEBUG_SLUB_ON things too (even if the
DEBUG_LIST thing won't catch list_move())

                      Linus
