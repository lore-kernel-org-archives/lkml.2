Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab2HMG47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 02:56:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38259 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab2HMG45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 02:56:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, kernel-janitors@vger.kernel.org,
        Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20120812145023.GA17077@localhost>
Date: Sun, 12 Aug 2012 23:56:45 -0700
In-Reply-To: <20120812145023.GA17077@localhost> (Fengguang Wu's message of
	"Sun, 12 Aug 2012 22:50:23 +0800")
Message-ID: <87k3x3z3de.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19bzPF4bzXbKIWPslaAHNt+kREeghCHSqs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.1 XMSubLong Long Subject
	*  1.0 XMGappySubj_02 Gappier still
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1387]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Fengguang Wu <fengguang.wu@intel.com>
X-Spam-Relay-Country: 
Subject: Re: [userns:userns-always-map-user-v45 80/99] fs/namespace.c:2290:1: error: unknown type name 'atomic64_t'
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fengguang Wu <fengguang.wu@intel.com> writes:

> Hi Geert,
>
> This is the build error I get, on Eric's userns tree.
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git userns-always-map-user-v45
> head:   38a0b1b84f5f613ff4e01fffda27f87d4cb2b649
> commit: 5ea9fc30545b658380d4794340227fe821b83701 [80/99] vfs: Add setns support for the mount namespace
> config: m68k-m5475evb_defconfig (attached as .config)
>
> All related error/warning messages:
>
> fs/namespace.c:2290:1: error: unknown type name 'atomic64_t'
> fs/namespace.c:2290:1: error: implicit declaration of function 'ATOMIC64_INIT' [-Werror=implicit-function-declaration]
> fs/namespace.c:2290:1: error: initializer element is not constant
> fs/namespace.c: In function 'alloc_mnt_ns':
> fs/namespace.c:2299:2: error: implicit declaration of function 'atomic64_add_return' [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

Fengguang is m68k the only place you are seeing build failures?

Exactly how I get a 64bit counter in that code path is not terribly
important.  I picked an atomic64_t because it looked simple and cheap.

If this is limited to a couple of m68k sub-arches I will let you guys
finish fixing this up so people can depend on atomic64_t being
available.  Otherwise it probably makes sense to go to with a different
abstraction.

> vim +2290 fs/namespace.c
>   2287	 * number incrementing at 10Ghz will take 12,427 years to wrap which
>   2288	 * is effectively never, so we can ignore the possibility.
>   2289	 */
>> 2290	static atomic64_t mnt_ns_seq = ATOMIC64_INIT(1);
>   2291	
>   2292	static struct mnt_namespace *alloc_mnt_ns(void)
>   2293	{
>
> ---
> 0-DAY kernel build testing backend         Open Source Technology Centre
> Fengguang Wu <wfg@linux.intel.com>                     Intel Corporation
