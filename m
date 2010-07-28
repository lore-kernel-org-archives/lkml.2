Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756415Ab0G1Woo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:44:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46147 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0G1Won (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 28 Jul 2010 18:44:43 -0400
Date: Wed, 28 Jul 2010 18:42:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: avi@redhat.com, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        npiggin@suse.de, Jeremy Fitzhardinge <jeremy@goop.org>,
        kvm@vger.kernel.org, bharata@in.ibm.com,
        Balbir Singh <balbir@in.ibm.com>, Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 0/4] Paravirt-spinlock implementation for KVM guests
 (Version 0)
Message-ID: <20100728224229.GA1693@phenom.dumpdata.com>
References: <20100726061150.GB21699@linux.vnet.ibm.com>
 <20100728221059.GA32739@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728221059.GA32739@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C50B2C7.0118:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 06:10:59PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 26, 2010 at 11:41:50AM +0530, Srivatsa Vaddagiri wrote:
> > This patch-series implements paravirt-spinlock implementation for KVM guests,
> > based heavily on Xen's implementation. I tried to refactor Xen's spinlock
> > implementation to make it common for both Xen and KVM - but found that 
> > few differences between Xen and KVM (Xen has the ability to block on a
> > particular event/irq for example) _and_ the fact that the guest kernel 
> > can be compiled to support both Xen and KVM hypervisors (CONFIG_XEN and
> > CONFIG_KVM_GUEST can both be turned on) makes the "common" code a eye-sore.
> > There will have to be:
> > 
> > 	if (xen) {
> > 		...
> > 	} else if (kvm) {
> > 		..
> > 	}
> > 
> > or possibly:
> > 
> > 	alternative(NOP, some_xen_specific_call, ....)
> 
> Why not utilize the pvops path?

Duh. You did use it. Sorry about the noise.
