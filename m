Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab0IEHJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 03:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0IEHJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 03:09:21 -0400
Message-ID: <4C83421A.7070501@redhat.com>
Date: Sun, 05 Sep 2010 10:09:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 2/3] KVM: SVM: Restore correct registers after sel_cr0
 intercept emulation
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com> <1283441387-7378-3-git-send-email-joerg.roedel@amd.com> <4C7FCA7A.1020809@redhat.com> <20100902162934.GD1964@amd.com>
In-Reply-To: <20100902162934.GD1964@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/02/2010 07:29 PM, Roedel, Joerg wrote:
>
>> I agree.  We can probably use X86EMUL_PROPAGATE_FAULT to abort
>> emulation, but looking at the code, it will take some refactoring.
> I thought of an X86EMUL_INTERCEPTED. An architecture specific function
> is called after instruction decoding which checks if an intercept is
> necessary. If it returns X86EMUL_INTERCEPTED then the instruction
> emulation is discarded and kvm goes straight back into the guest.

Yes, this sounds just right.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

