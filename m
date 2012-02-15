Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab2BONjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:39:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236Ab2BONjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:39:51 -0500
Message-ID: <4F3BB59D.2020505@redhat.com>
Date: Wed, 15 Feb 2012 15:39:41 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Rusty Russell <rusty@ozlabs.org>
CC: Anthony Liguori <anthony@codemonkey.ws>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com> <20120205093723.GQ23536@redhat.com> <4F2E4F8B.8090504@redhat.com> <20120205095153.GA29265@redhat.com> <4F2EAFF6.7030006@codemonkey.ws> <4F2F9E89.7090607@redhat.com> <87vcnih5qt.fsf@rustcorp.com.au>
In-Reply-To: <87vcnih5qt.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 08:12 PM, Rusty Russell wrote:
> > I would really love to have this, but the problem is that we'd need a
> > general purpose bytecode VM with binding to some kernel APIs.  The
> > bytecode VM, if made general enough to host more complicated devices,
> > would likely be much larger than the actual code we have in the kernel now.
>
> We have the ability to upload bytecode into the kernel already.  It's in
> a great bytecode interpreted by the CPU itself.

Unfortunately it's inflexible (has to come with the kernel) and open to
security vulnerabilities.

> If every user were emulating different machines, LPF this would make
> sense.  Are they?  

They aren't.

> Or should we write those helpers once, in C, and
> provide that for them.

There are many of them: PIT/PIC/IOAPIC/MSIX tables/HPET/kvmclock/Hyper-V
stuff/vhost-net/DMA remapping/IO remapping (just for x86), and some of
them are quite complicated.  However implementing them in bytecode
amounts to exposing a stable kernel ABI, since they use such a vast
range of kernel services.

-- 
error compiling committee.c: too many arguments to function

