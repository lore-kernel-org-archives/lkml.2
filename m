Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1IFSvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:51:06 -0400
Received: from claw.goop.org ([74.207.240.146]:50819 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670Ab1IFSvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:51:03 -0400
Message-ID: <4E666B92.9010300@goop.org>
Date: Tue, 06 Sep 2011 11:50:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com> <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org> <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org> <20110906151408.GA7459@redhat.com> <4E66615E.8070806@goop.org> <20110906182758.GR5795@redhat.com>
In-Reply-To: <20110906182758.GR5795@redhat.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2011 11:27 AM, Don Zickus wrote:
>> But on the other hand, I don't really care if you can say that this path
>> will never be called in a virtual machine.
> Does virtual machines support hot remove of cpus?  Probably not
> considering bare-metal barely supports it.

The only reason you'd want to is to add/remove VCPUs as a mechanism of
resource control, so if you were removing a VCPU it wouldn't matter much
which one you choose.  In other words, there's no reason you'd ever need
to remove the BSP in favour of one of the other CPUs.

Anyway, I'm not going to lose any sleep over this issue.

    J
