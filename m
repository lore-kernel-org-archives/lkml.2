Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758874Ab2JKQdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:33:55 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:17859
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758142Ab2JKQdv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:33:51 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h944hd2bhf0ah107ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1155h)
Date: Thu, 11 Oct 2012 11:33:31 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the
 powerpc-merge tree
To: Alexander Graf <agraf@suse.de>
CC: Tabi Timur-B04825 <B04825@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <1349970603.6903.2@snotra>
	<CDB8B53D-EEC2-41A4-9BEA-66783409EE66@suse.de>
In-Reply-To: <CDB8B53D-EEC2-41A4-9BEA-66783409EE66@suse.de> (from
	agraf@suse.de on Thu Oct 11 10:56:51 2012)
X-Mailer: Balsa 2.4.11
Message-ID: <1349973211.6903.3@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 10:56:51 AM, Alexander Graf wrote:
> 
> On 11.10.2012, at 17:50, Scott Wood wrote:
> 
> > On 10/11/2012 08:04:58 AM, Alexander Graf wrote:
> >> On 11.10.2012, at 05:32, Tabi Timur-B04825 wrote:
> >> > On Wed, Oct 10, 2012 at 9:47 PM, Stephen Rothwell  
> <sfr@canb.auug.org.au> wrote:
> >> >
> >> >> Commit 549d62d889b4 ("KVM: PPC: use definitions in epapr header
> >> >> for hcalls") from the kvm-ppc tree added an include of  
> asm/epapr_hcall.h
> >> >> to the user visible part of asm/kvm_para.h so asm/epapr_hcall.h  
> became a
> >> >> user visible header file.
> >> >
> >> > Any real user-space code that tries to call any of the functions  
> in
> >> > epapr_hcall.h will cause an exception.
> >
> > Actually it'll cause a linker error, as of the "Don't use hardcoded  
> opcode for ePAPR hcall invocation" patch.
> >
> >> > Claiming that kernel header files that KVM needs are suddenly
> >> > user-space header files doesn't make much sense to me, but I  
> guess
> >> > it's not my decision.
> >> This is about kvm_host.h, which is the part that is exported to  
> user space. It usually contains constants and structs that are  
> required for the API.
> >
> > s/kvm_host/kvm_para/
> >
> > I'm not sure anything in kvm_para.h or epapr_hcalls.h would be of  
> use to userspace, but it would be of use to the guest OS, so it's  
> still not kernel-internal.
> >
> > The variable externs should be #ifdef __KERNEL__ as David points  
> out.  The asm stuff could still be useful in a guest OS if the guest  
> provides epapr_hypercall_start.
> 
> I don't think we should worry about guest kernel code potentially  
> having use for this. Let's make the user space headers be great for  
> user space usage, not for guest code usage :).

Well, that asm stuff started out as a guest header (from Freescale's  
Topaz hypervisor), not a Linux header. :-)

-Scott
