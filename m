Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab1BQS6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:58:08 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55693 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab1BQS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:58:05 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
	<20110216193700.GA6377@elte.hu>
	<AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
	<AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
	<20110217090910.GA3781@tiehlicka.suse.cz>
	<AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	<20110217163531.GF14168@elte.hu>
Date: Thu, 17 Feb 2011 10:57:54 -0800
In-Reply-To: <20110217163531.GF14168@elte.hu> (Ingo Molnar's message of "Thu,
	17 Feb 2011 17:35:31 +0100")
Message-ID: <m1pqqqfpzh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/2xbpyW1E7LNFjR9w7OIROL1za0tXHMq0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> And in addition, I don't see why others wouldn't see it (I've got
>> DEBUG_PAGEALLOC and SLUB_DEBUG_ON turned on myself, and I know others
>> do too).
>
> I've done extensive randconfig testing and no crash triggers for typical workloads 
> on a typical dual-core PC. If there's a generic crashes in there my tests tend to 
> trigger them at least 10x as often as regular testers ;-) But the tests are still 
> only statistical so the race could simply be special and missed by the tests.
>
>> So I'm wondering what triggers it. Must be something subtle.
>
> I think what Michal did before he got the corruption seemed somewhat atypical: 
> suspend/resume and udevd wifi twiddling, right?
>
> Now, Eric's crashes look similar - and he does not seem to have done anything 
> special to trigger the crashes.
>
> Eric, could you possibly describe your system in a bit more detail, does it do 
> suspend and does the box use wifi actively? Anything atypical in your setup or usage 
> that doesnt match a bog-standard whitebox PC with LAN? Swap to file? NFS? FUSE? 
> Anything that is even just borderline atypical.

10G RAM
2G Swap
dual socket system
4 cores per socket
No hyperthreading.

fedora 14
ext4 on all filesystems

The biggest difference is I beat the system to death with automated builds.

I was about to say this happens with DEBUG_PAGEALLOC enabled but it
appears that options keeps eluding my fingers when I have a few minutes
to play with it.  Perhaps this time will be the charm.

The biggest difference may be that I am constantly stressing the system
to the edge of triggering the OOM killer.  My builds and tests are
greedy when it comes to memory.

I guess also I only see the bad PMD on processes that exit.  So it may
be that it is a matter of timing to see it.

Eric
