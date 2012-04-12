Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761578Ab2DLAa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:30:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761562Ab2DLAax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:30:53 -0400
Date: Wed, 11 Apr 2012 21:26:46 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 <x86@kernel.org>,
        Avi Kivity <avi@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>,
        Virtualization <virtualization@lists.linux-foundation.org>,
        Xen <xen-devel@lists.xensource.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC V5 0/6] kvm : Paravirt-spinlock support for KVM guests
Message-ID: <20120412002646.GC32051@amt.cnet>
References: <20120323080503.14568.43092.sendpatchset@codeblue>
 <4F73593D.5020305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F73593D.5020305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 12:02:29AM +0530, Raghavendra K T wrote:
> On 03/23/2012 01:35 PM, Raghavendra K T wrote:
> >The 6-patch series to follow this email extends KVM-hypervisor and Linux guest
> >running on KVM-hypervisor to support pv-ticket spinlocks, based on Xen's
> >implementation.
> >
> >One hypercall is introduced in KVM hypervisor,that allows a vcpu to kick
> >another vcpu out of halt state.
> >The blocking of vcpu is done using halt() in (lock_spinning) slowpath.
> >one MSR is added to aid live migration.
> >
> >Changes in V5:
> >- rebased to 3.3-rc6
> >- added PV_UNHALT_MSR that would help in live migration (Avi)
> >- removed PV_LOCK_KICK vcpu request and pv_unhalt flag (re)added.
> 
> Sorry for pinging
> I know it is busy time. But I hope to get response on these patches
> in your free time, so that I can target next merge window for this.
> (whether it has reached some good state or it is heading in reverse
> direction!). it would really boost my morale.
> especially MSR stuff and dropping vcpu request bit for PV unhalt.
> 
> - Raghu

Looks good. Only the MSR appears an abuse, since there is no need
to expose the info to the guest.

