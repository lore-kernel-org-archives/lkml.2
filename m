Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab0G1LeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 07:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab0G1LeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 07:34:18 -0400
Message-ID: <4C5015B3.8010003@redhat.com>
Date: Wed, 28 Jul 2010 14:34:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com> <1280247261-19115-3-git-send-email-joerg.roedel@amd.com> <4C4F2643.8080507@redhat.com> <20100728093708.GD26098@amd.com> <4C500636.1070708@redhat.com> <20100728112540.GE26098@amd.com>
In-Reply-To: <20100728112540.GE26098@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/28/2010 02:25 PM, Roedel, Joerg wrote:
> On Wed, Jul 28, 2010 at 06:28:06AM -0400, Avi Kivity wrote:
>> We have a slightly different problem, if the nested guest manages to get
>> an instruction to be emulated by the host (if the guest assigned it the
>> cirrus framebuffer, for example, so from L1's point of view it is RAM,
>> but from L0's point of view it is emulated), then we miss the
>> intercept.  L2 could take over L1 this way.
> I wonder how this could happen. Shouldn't the shadow paging code take
> care of this?
>

L1 thinks the memory is RAM, so it maps it directly and forgets about 
it.  L0 knows it isn't, so it leaves it unmapped and emulates any 
instruction which accesses it.  The emulator needs to check whether the 
instruction is intercepted or not.

Note, I think if the instruction operand is in mmio, we're safe, since 
the intercept has higher priority than memory access.  But if the 
instruction itself is on mmio, or if we entered the emulator through smp 
trickery, then the emulator will execute the instruction in nested guest 
context.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

