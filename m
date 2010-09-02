Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab0IBQCI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:02:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756580Ab0IBQCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:02:06 -0400
Message-ID: <4C7FCA7A.1020809@redhat.com>
Date: Thu, 02 Sep 2010 19:02:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2/3] KVM: SVM: Restore correct registers after sel_cr0
 intercept emulation
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com> <1283441387-7378-3-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1283441387-7378-3-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/02/2010 06:29 PM, Joerg Roedel wrote:
> This patch implements restoring of the correct rip, rsp, and
> rax after the svm emulation in KVM injected a selective_cr0
> write intercept into the guest hypervisor. The problem was
> that the vmexit is emulated in the instruction emulation
> which later commits the registers right after the write-cr0
> instruction. So the l1 guest will continue to run with the
> l2 rip, rsp and rax resulting in unpredictable behavior.
>

Please post a unit test for this.

> This patch is not the final word, it is just an easy patch
> to fix the issue. The real fix will be done when the
> instruction emulator is made aware of nested virtualization.
> Until this is done this patch fixes the issue and provides
> an easy way to fix this in -stable too.

I agree.  We can probably use X86EMUL_PROPAGATE_FAULT to abort 
emulation, but looking at the code, it will take some refactoring.

-- 
error compiling committee.c: too many arguments to function

