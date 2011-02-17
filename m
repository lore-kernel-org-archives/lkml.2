Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab1BQTbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 14:31:18 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50460 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1BQTbN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 14:31:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
	<20110216193700.GA6377@elte.hu>
	<AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
	<AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
	<20110217090910.GA3781@tiehlicka.suse.cz>
	<AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	<20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
	<AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
Date: Thu, 17 Feb 2011 11:31:07 -0800
In-Reply-To: <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 17 Feb 2011 11:11:51 -0800")
Message-ID: <m1zkpue9vo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/KsCjXdqJ2uFY2QHLeF2PlsQ5b1ekCrXQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Feb 17, 2011 at 10:57 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> fedora 14
>> ext4 on all filesystems
>
> Your dmesg snippets had ext3 mentioned, though:
>
>   <6>EXT3-fs (sda1): recovery required on readonly filesystem
>   <6>EXT3-fs (sda1): write access will be enabled during recovery
>   <6>EXT3-fs: barriers not enabled
>   ..
>   <6>EXT3-fs (sda1): recovery complete
>   <6>EXT3-fs (sda1): mounted filesystem with ordered data mode
>   <6>dracut: Mounted root filesystem /dev/sda1
>
> not that I see that it should matter, but there's been some bigger
> ext3 changes too (like the batched discard).
>
> I don't really think ext3 is the issue, though.

Oh right.  I changed the configuration but I haven't upgraded this
machine off of ext3 root yet.   The partition where all of the data is
going is ext4.  Creating a chrooted build environment on the fly is
great but it can momentarily swamp the disk.

>> I was about to say this happens with DEBUG_PAGEALLOC enabled but it
>> appears that options keeps eluding my fingers when I have a few minutes
>> to play with it.  Perhaps this time will be the charm.
>
> Please do. You seem to be much better at triggering it than anybody
> else. And do the DEBUG_LIST and DEBUG_SLUB_ON things too (even if the
> DEBUG_LIST thing won't catch list_move())

DEBUG_LIST I did manage to get enabled and it didn't catch anything,
despite some bad PMD's showing up.  The other two should be enabled in
the kernel version I am building right now.

It does look like this can go quiet for a days at a time.  The 17th is
the first my logs show of it since the 14th.

messages:Feb 14 17:55:12 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88028c45f748 pmd:28c45f067
messages:Feb 14 17:55:12 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88028c45f748 pmd:28c45f067
messages:Feb 17 00:49:53 bs38 kernel: BUG: Bad page map in process Sysdb  pte:ffff8802742b3758 pmd:2742b3067
messages:Feb 17 00:49:53 bs38 kernel: BUG: Bad page map in process Sysdb  pte:ffff8802742b3758 pmd:2742b3067
messages:Feb 17 10:00:43 bs38 kernel: BUG: Bad page map in process cc1plus  pte:ffff880190f73758 pmd:190f73067
messages:Feb 17 10:00:43 bs38 kernel: BUG: Bad page map in process cc1plus  pte:ffff88025efed758 pmd:25efed067
messages:Feb 17 10:00:43 bs38 kernel: BUG: Bad page map in process cc1plus  pte:ffff88025efed758 pmd:25efed067
messages:Feb 17 10:00:43 bs38 kernel: BUG: Bad page map in process cc1plus  pte:ffff880190f73758 pmd:190f73067

Eric
