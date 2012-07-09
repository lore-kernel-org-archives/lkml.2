Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2GIHEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:04:08 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33871 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2GIHEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:04:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, hacklu <embedway.linux@gmail.com>,
        linux-kernel@vger.kernel.org
References: <4FF06701.6010004@zytor.com> <4FF06DF4.4000006@zytor.com>
	<87wr2nsbvi.fsf@xmission.com> <4FF0769F.8090105@zytor.com>
	<87sjdbsb0v.fsf@xmission.com> <4FF07E66.2020706@zytor.com>
	<87d34fs914.fsf@xmission.com> <4FF085B1.6070604@zytor.com>
	<87a9zj9w43.fsf@xmission.com> <4FF098E2.3040307@zytor.com>
	<20120702165633.GA555@google.com>
Date: Mon, 09 Jul 2012 00:03:58 -0700
In-Reply-To: <20120702165633.GA555@google.com> (Tejun Heo's message of "Mon, 2
	Jul 2012 09:56:33 -0700")
Message-ID: <87fw914dr5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19BoGrY4zRB136jrQLcA3anvB5wtipDxSE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] x86, boot: Optimize the elf header handling.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, guys.
>
> On Sun, Jul 01, 2012 at 11:37:22AM -0700, H. Peter Anvin wrote:
>> If we don't need it, I think we can use -z max-page-size=4096, but we
>> use the PMD alignment for percpu on x86-64; Tejun, does that apply to
>> the .data..percpu section in the executable as well?
>
> I don't think the .data..percpu section needs 2M alignment.  The
> percpu data section is only used as init template and actual percpu
> addresses always go through offsetting against __per_cpu_offset[] - no
> matter what the vaddrs in the vmlinux are, they get offsetted into 2M
> aligned linear address if necessary.  I think the only alignment
> .data..percpu needs is cacheline alignment for separating its
> subsections.

Thanks.  My basic testing isn't showing any problems.

Of course all that changed was where in the vmlinux file not where
in physical memory the data was loaded, so problems would really
surprise me. 

Eric

