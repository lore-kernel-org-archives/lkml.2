Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0LALii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:38:38 -0500
Received: from mailgw12.technion.ac.il ([132.68.225.12]:19503 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0LALih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:38:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACrC9UyERHMG/2dsb2JhbACjEnHEEAKFRQSKYw
X-IronPort-AV: E=Sophos;i="4.59,283,1288562400"; 
   d="scan'208";a="18659299"
Date: Wed, 1 Dec 2010 13:38:30 +0200
From: "Nadav Har'El" <nyh@math.technion.ac.il>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2
Message-ID: <20101201113830.GA5469@fermat.math.technion.ac.il>
References: <4CF3D093.40604@redhat.com> <1291049509-3430-1-git-send-email-joerg.roedel@amd.com> <20101201080149.GA29486@fermat.math.technion.ac.il> <20101201100359.GG2258@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101201100359.GG2258@amd.com>
User-Agent: Mutt/1.4.2.2i
Hebrew-Date: 24 Kislev 5771
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 01, 2010, Roedel, Joerg wrote about "Re: [PATCH 0/3] KVM: Introduce VCPU-wide notion of guest-mode V2":
> Btw, another idea which came up recently was to concentrate the actuall
> vmexit emulation at a single point. Every code place which does the exit
> directly today will be changed to only set a request-bit and the real
> exit is then done later. Your code might already do this, I havn't

In my current patches, there is single function nested_vmx_vmexit() which
emulates the exit (exits from L2 to L1), but it is called in several places,
the most significant are of course in vmx_handle_exit (when L1 asked an exit
on the given event), and vmx_interrupt_allowed (when we inject an interrupt
and L1 asked to exit on interrupts). This area of my code definitely needs
some reorganization, as Gleb pointed out in his review.

> This would fit very well in the generic code because it already has
> request-bit infrastructure. What do you think, can nested VMX also make
> use of that too?

Can you please say a few words why you'd want to move this nested-exit
request bit to x86.c? Do you want to move some of the exit logic to x86.c -
e.g., for the injection logic?

Nadav.

-- 
Nadav Har'El                        |   Wednesday, Dec  1 2010, 24 Kislev 5771
nyh@math.technion.ac.il             |-----------------------------------------
Phone +972-523-790466, ICQ 13349191 |Fame: when your name is in everything but
http://nadav.harel.org.il           |the phone book.
