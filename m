Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab2HMQOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:14:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52329 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab2HMQOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:14:05 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20120813133910.GA30532@localhost>
References: <20120812145023.GA17077@localhost> <87k3x3z3de.fsf@xmission.com> <20120813133910.GA30532@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 13 Aug 2012 09:13:09 -0700
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, kernel-janitors@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <63f9e712-3cd1-4020-9df6-8fb8d9c3f1ec@email.android.com>
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19BwcMxm31I5i1mp7wv6R6e/KQtvYXBP8c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0496]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [userns:userns-always-map-user-v45 80/99] fs/namespace.c:2290:1: error: unknown type name 'atomic64_t'
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> wrote:

>On Sun, Aug 12, 2012 at 11:56:45PM -0700, Eric W. Biederman wrote:
>> Fengguang Wu <fengguang.wu@intel.com> writes:
>> 
>> > Hi Geert,
>> >
>> > This is the build error I get, on Eric's userns tree.
>> >
>> > tree:  
>git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git
>userns-always-map-user-v45
>> > head:   38a0b1b84f5f613ff4e01fffda27f87d4cb2b649
>> > commit: 5ea9fc30545b658380d4794340227fe821b83701 [80/99] vfs: Add
>setns support for the mount namespace
>> > config: m68k-m5475evb_defconfig (attached as .config)
>> >
>> > All related error/warning messages:
>> >
>> > fs/namespace.c:2290:1: error: unknown type name 'atomic64_t'
>> > fs/namespace.c:2290:1: error: implicit declaration of function
>'ATOMIC64_INIT' [-Werror=implicit-function-declaration]
>> > fs/namespace.c:2290:1: error: initializer element is not constant
>> > fs/namespace.c: In function 'alloc_mnt_ns':
>> > fs/namespace.c:2299:2: error: implicit declaration of function
>'atomic64_add_return' [-Werror=implicit-function-declaration]
>> > cc1: some warnings being treated as errors
>> 
>> Fengguang is m68k the only place you are seeing build failures?
>
>Yes.
>
>> Exactly how I get a 64bit counter in that code path is not terribly
>> important.  I picked an atomic64_t because it looked simple and
>cheap.
>
>Fair enough. As long as it's not in hot code path, it definitely helps
>to use simple solutions.
>
>> If this is limited to a couple of m68k sub-arches I will let you guys
>> finish fixing this up so people can depend on atomic64_t being
>> available.  Otherwise it probably makes sense to go to with a
>different
>> abstraction.
>
>I'd suggest to fix it in m68k and make atomic64_t generally available.

Fengguang in your testing on any architechtures is atomic64_t missing on anything except some m68k subarchtechtures?

Eric

