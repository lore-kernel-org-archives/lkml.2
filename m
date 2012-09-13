Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab2IMK3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:29:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34311 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341Ab2IMK3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:29:44 -0400
Date: Thu, 13 Sep 2012 11:29:38 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 06/25] docs: Xen ARM DT bindings
Message-ID: <20120913102938.GB2470@linaro.org>
References: <alpine.DEB.2.02.1208161618550.4850@kaball.uk.xensource.com>
 <1345131377-14713-6-git-send-email-stefano.stabellini@eu.citrix.com>
 <503BFCD8.5090804@gmail.com>
 <alpine.DEB.2.02.1208281823270.15568@kaball.uk.xensource.com>
 <alpine.DEB.2.02.1209121849200.15568@kaball.uk.xensource.com>
 <50514634.3080303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50514634.3080303@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 09:34:28PM -0500, Rob Herring wrote:
> On 09/12/2012 01:14 PM, Stefano Stabellini wrote:
> > On Wed, 12 Sep 2012, Stefano Stabellini wrote:
> >> On Tue, 28 Aug 2012, Rob Herring wrote:
> >>> You should look at ePAPR 1.1 which defines hypervisor related bindings.
> >>> While it is a PPC doc, we should reuse or extend what makes sense.
> >>>
> >>> See section 7.5:
> >>>
> >>> https://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.1.pdf
> >>
> >> Thanks for the link, I wasn't aware of ePAPR.
> >>
> >> The hypervisor node defined by ePAPR is not very different from what I
> >> am proposing. Should I try to be compatible with the hypervisor
> >> specification above (as in compatible = "epapr,hypervisor-1.1")?
> >> Or should I just use it as a reference for my own specification?
> >>
> >> Personally I would rather avoid full compatibility with ePAPR.
> > 
> > In particular reading section 7.5, these are the required properties of
> > the ePAPR hypervisor node:
> > 
> > - compatible = "epapr,hypervisor-1.1"
> > compared to what I am proposing, it is laking information about what
> > hypervisor we are talking about (xen, kvm, vmware, etc) and the version
> > of the ABI (xen-4.2).
> 
> compatible properties are often changed. If we do deviate on the rest of
> the binding, then it needs to be different.
> 
> Turns out that powerpc KVM guests use "linux,kvm" and "epapr,hypervisor"
> doesn't even appear in the kernel.
> 
> We also perhaps have to consider the possibility of Xen on PowerPC. Then
> alignment is more important.
> 
> > - hcall-instructions
> > potentially interesting, but given that for Xen we are quite happy with
> > HVC, we are not going to add any secondary hypercall mechanisms,
> > therefore at the moment it would just result in a BUG if the specified
> > hcall instruction is != HVC. Besides if somebody else wanted to
> > implemented the Xen hypercall interface in a different way they could
> > just reimplement the hypercall wrappers, that would be easier than
> > trying to do it with this property.
> 
> It's really about the parameters passed with the HVC. The ePAPR may be a
> good model for defining this. Just grepping "hypervisor" under
> arch/powerpc, it's pretty clear hypervisor support happened first and
> the ePAPR came second. Hopefully we can avoid that for ARM.

Do you think it's feasible to standardise on some interoperable ABI for
kvm and Xen?  This sounds pretty optimistic, but I'm not aware of all
the technicalities, or what possible third-party hypervisors are out
there.

If we could do it, it would be good.  But I have my doubts about the
feasibility and the benefits.  If different hypervisors are significantly
imcompatible, then having a common low-level ABI doesn't help all that
much.

Cheers
---Dave
