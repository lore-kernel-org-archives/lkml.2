Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872Ab1ELOqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1ELOqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:46:17 -0400
Message-ID: <4DCBF2A7.4010002@redhat.com>
Date: Thu, 12 May 2011 17:45:59 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com> <20110512131130.GG8707@8bytes.org> <4DCBE13A.2050204@redhat.com> <20110512142449.GI8707@8bytes.org> <4DCBF0B7.7080102@redhat.com>
In-Reply-To: <4DCBF0B7.7080102@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 05:37 PM, Avi Kivity wrote:
>
> I've considered something similar for mmio - use hypercalls for 
> ordinary mmio to avoid calling into the emulator - but virtio uses pio 
> which isn't emulated and we don't have massive consumers of mmio 
> (except perhaps hpet).

Say,

enum {
    KVM_OP_MMIO_READ = 1,
    KVM_OP_MMIO_WRITE = 2,
    KVM_OP_PIO_READ = 3,
    KVM_OP_PIO_WRITE = 4,
    KVM_OP_MSR_READ = 5,
    KVM_OP_MSR_WRITE = 6,
    KVM_OP_HLT = 7, /* so we can program the apic timer and sleep */
}

struct kvm_batch_op {
     u8 op;
     u8 result;
     u8 size;
     u8 reserved[5];
     u64 address;
     u64 data;
};

int kvm_batch(int nr, u64 kvm_batch_op_phys);

This is really repeating Xen PV though (different ops), not sure it's 
worth the intrusiveness.

-- 
error compiling committee.c: too many arguments to function

