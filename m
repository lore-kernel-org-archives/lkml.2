Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030272Ab2HPQRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030207Ab2HPQRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:17:19 -0400
Message-ID: <502D1D09.1030506@redhat.com>
Date: Thu, 16 Aug 2012 19:17:13 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/12] KVM: introduce readonly memslot
References: <5020E423.9080004@linux.vnet.ibm.com> <20120810181422.GA14892@amt.cnet> <502A5A01.6040505@redhat.com> <20120814155106.GA22249@amt.cnet> <502B7D7E.20902@redhat.com> <20120815175338.GA18452@amt.cnet> <502CB745.8060709@redhat.com> <20120816155739.GA23247@amt.cnet>
In-Reply-To: <20120816155739.GA23247@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 06:57 PM, Marcelo Tosatti wrote:
>> 
>> Correct.  But the chipset is also able to to write-protect some ranges
>> in the 0xc0000-0x100000 area via the PAM.  It is able to write-protect
>> both RAM and PCI memory (usually mapped to flash).
> 
> You are convinced that adding read-write protection information to the
> memory slots, which controls access by the guest, in addition to the
> userspace host pagetables, is useful. OK.

In fact if we started from scratch I'd go for one huge slot, with
PROT_NONE for mmio and non-kvm APIs for dirty bitmaps, and use Linux mm
APIs to manage the details.  This would make kvm x86_64 only (no way to
access the PCI space on i386) but it would simplify a lot of the
internal translation layer.  But we're not there.


-- 
error compiling committee.c: too many arguments to function
