Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2ALAZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 19:25:34 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:54503 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2ALAZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 19:25:31 -0500
Message-ID: <4F0E28C7.2010409@oss.ntt.co.jp>
Date: Thu, 12 Jan 2012 09:26:47 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Nadav Amit <namit@cs.technion.ac.il>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: Re: [PATCH 1/2] KVM: Exception during emulation decode should propagate
References: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il> <20120112071137.303628cea69b79868956d860@gmail.com>
In-Reply-To: <20120112071137.303628cea69b79868956d860@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/12 7:11), Takuya Yoshikawa wrote:
> On Wed, 11 Jan 2012 18:53:30 +0200
> Nadav Amit<namit@cs.technion.ac.il>  wrote:
>
>> An exception might occur during decode (e.g., #PF during fetch).
>> Currently, the exception is ignored and emulation is performed.

Note that the decode/emulation will not be continued in such a case.

insn_fetch() is a bit tricky macro and it contains "goto done" to outside.
So if an error happens during fetching the instruction, x86_decode_insn()
will handle the X86EMUL_* fault value and returns FAIL immediately.

	Takuya

>
> When I cleaned up insn_fetch(), I thought that fetching the instruction
> which is being executed by the guest cannot cause #PF.
>
> The possibility that a meaningless userspace might similtaneously unmap
> the page, noted by Avi IIRC, was ignored intentionally, so we just fail
> in such a case.
>
> Did you see any real problem?
>
> 	Takuya
>
>
>> Instead, emulation should be skipped and the fault should be injected.
>> Skipping instruction should report a failure in this case.
