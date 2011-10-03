Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab1JCKKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 06:10:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56661 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab1JCKKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 06:10:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: prasad@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, crash-utility@redhat.com,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, "Luck\, Tony" <tony.luck@intel.com>,
        anderson@redhat.com, tachibana@mxm.nes.nec.co.jp,
        oomichi@mxs.nes.nec.co.jp
References: <20111003070735.GJ2223@in.ibm.com>
	<20111003073203.GA22694@in.ibm.com>
Date: Mon, 03 Oct 2011 03:10:43 -0700
In-Reply-To: <20111003073203.GA22694@in.ibm.com> (K. Prasad's message of "Mon,
	3 Oct 2011 13:02:03 +0530")
Message-ID: <m162k64c7w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/VTlcVYqa01lk2QSpT2grss98BKQVanc4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  1.0 XMSlimDrugH Weight loss drug headers
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;prasad@linux.vnet.ibm.com
X-Spam-Relay-Country: **
Subject: Re: [Patch 1/4][kernel][slimdump] Add new elf-note of type NT_NOCOREDUMP to capture slimdump
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"K.Prasad" <prasad@linux.vnet.ibm.com> writes:

> There are certain types of crashes induced by faulty hardware in which
> capturing crashing kernel's memory (through kdump) makes no sense (or sometimes
> dangerous).
>
> A case in point, is unrecoverable memory errors (resulting in fatal machine
> check exceptions) in which reading from the faulty memory location from the
> kexec'ed kernel will cause double fault and system reset (leaving no
> information for the user).

It does make plenty of sense, and I capture the all of the time.
It totally doesn't make sense to do this in the kernel when we can
filter this from userspace just fine.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I thought we already had this discussion.  Why is this silliness coming
back?

I especially dislike the notion of hardcoding policy in the kernel like this.

Eric
