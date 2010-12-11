Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab0LKH1p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 02:27:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021Ab0LKH1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 02:27:44 -0500
Message-ID: <4D0327E0.6070500@redhat.com>
Date: Sat, 11 Dec 2010 09:27:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 3/3] kvm: use yield_to instead of sleep in kvm_vcpu_on_spin
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144516.45a0385d@annuminas.surriel.com> <4CFB8BFA.4040100@redhat.com> <4D0008D5.1040102@redhat.com> <4D00AF3C.40603@redhat.com> <4D010CD4.4020400@redhat.com>
In-Reply-To: <4D010CD4.4020400@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 07:07 PM, Rik van Riel wrote:
>> Right. May be clearer by using a for () loop instead of the goto.
>
>
> And open coding kvm_for_each_vcpu ?
>
> Somehow I suspect that won't add to clarity...

No, I meant having a for (pass = 0; pass < 2; ++pass) and nesting 
kvm_for_each_vcpu() in it.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

