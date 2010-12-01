Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab0LAILt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 03:11:49 -0500
Received: from mailgw12.technion.ac.il ([132.68.225.12]:50201 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab0LAILs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 03:11:48 -0500
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Dec 2010 03:11:47 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMaP9UyERHMG/2dsb2JhbACjEXHEBwKFRQSKYw
X-IronPort-AV: E=Sophos;i="4.59,282,1288562400"; 
   d="scan'208";a="18573978"
Date: Wed, 1 Dec 2010 10:01:49 +0200
From: "Nadav Har'El" <nyh@math.technion.ac.il>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2
Message-ID: <20101201080149.GA29486@fermat.math.technion.ac.il>
References: <4CF3D093.40604@redhat.com> <1291049509-3430-1-git-send-email-joerg.roedel@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291049509-3430-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.4.2.2i
Hebrew-Date: 24 Kislev 5771
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010, Joerg Roedel wrote about "[PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2":
> Hi Avi, Hi Marcelo,
> 
> here is the re-spin I promised. The change to V1 are essentially the
> renames:
> 
> 	kvm_vcpu_enter_gm -> enter_guest_mode
> 	kvm_vcpu_leave_gm -> leave_guest_mode
> 	kvm_vcpu_is_gm    -> is_guest_mode

I like this concept, and will be happy to change the nested VMX code to use
it as well.

One small thing: After the name change, it might not be obvious on first
sight that these functions refer to the state of the vcpu, not the state
of the actual CPU (which, if you think about it, is never in guest mode while
KVM code is running ;-)). I think that a short comment before the definition
of these functions might be useful - perhaps saying that they pertain to a
hypervisor running in the vcpu (i.e., nested virtualization).

Nadav.

-- 
Nadav Har'El                        |   Wednesday, Dec  1 2010, 24 Kislev 5771
nyh@math.technion.ac.il             |-----------------------------------------
Phone +972-523-790466, ICQ 13349191 |How do you get holy water? Boil the hell
http://nadav.harel.org.il           |out of it.
