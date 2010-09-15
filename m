Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab0IOOsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:48:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab0IOOsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:48:16 -0400
Date: Wed, 15 Sep 2010 11:48:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: Use base_role.nxe for mmu.nx
Message-ID: <20100915144801.GA14336@amt.cnet>
References: <1284479173-4515-1-git-send-email-joerg.roedel@amd.com>
 <1284479173-4515-3-git-send-email-joerg.roedel@amd.com>
 <20100914220836.GA3553@amt.cnet>
 <20100915084833.GH17759@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915084833.GH17759@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 10:48:33AM +0200, Roedel, Joerg wrote:
> On Tue, Sep 14, 2010 at 06:08:37PM -0400, Marcelo Tosatti wrote:
> > 
> > For tdp better set base_role.nxe to zero, otherwise duplicate tdp
> > pagetables can be created if the guest switches between nx/non-nx.
> >
> 
> This does not work because bit 63 is marked as reserved if base_role.nxe
> is 0. If the walk_addr_generic function then runs with tdp enabled it
> would report a set nx bit as a rsvd fault.

Ah, OK.

> We also can't use is_nx() in those path because it does not distinguish
> between l1 and l2 nx. Are there guests that switch the efer.nx bit
> regularly enough so that it matters? If so I would suggest to drop this
> patch and keep mmu.nx.

Well, i don't think it would be a common scenario. Ignore me.

