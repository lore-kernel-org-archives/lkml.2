Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab2JKNIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:08:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756353Ab2JKNIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:08:09 -0400
Subject: Re: linux-next: manual merge of the kvm-ppc tree with the powerpc-merge tree
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <13876.1349947620@warthog.procyon.org.uk>
Date: Thu, 11 Oct 2012 15:08:01 +0200
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, B04825@freescale.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Yu <yu.liu@freescale.com>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4C573632-7629-4E7A-8A67-FD4698B7430D@suse.de>
References: <20121011120502.0211f1267dedf3776e4cf85b@canb.auug.org.au> <13876.1349947620@warthog.procyon.org.uk>
To: David Howells <dhowells@redhat.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11.10.2012, at 11:27, David Howells wrote:

> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> I just removed epapr_hcalls.h from the Kbuild file as I am not sure how
>> it should be broken up.  David, can you have a look at this, please?
> 
> Files should be broken up along around __KERNEL__ conditionals.  If there are
> no __KERNEL__ conditionals, it is assumed that the file is entirely UAPI and
> can just be moved.
> 
> The problem appears to be this commit:
> 
> 	https://github.com/agraf/linux-2.6/commit/4c09029a5639c955fcf6d65205796e4f1208aed3
> 
> 	From: Liu Yu <yu.liu@freescale.com>
> 	Subject: KVM: PPC: Add support for ePAPR idle hcall in host kernel
> 
> Just makes epapr_hcalls.h part of the userspace API in its entirety by this bit
> of the patch:
> 
> 	+header-y += epapr_hcalls.h
> 
> whilst not adding any __KERNEL__ guards - which is almost certainly incorrect.
> 
> At the very least, I would say that the global variable declarations need
> limiting to kernel space, and thus so do the inline functions as they emit
> inline assembly to jump somewhere specified by one of the global variables
> (actually a code array).
> 
> So for manual splitting purposes, I would go with just moving all the #defines
> prior to the __ASSEMBLY__ guard out to uapi.  Everything within the
> __ASSEMBLY__ guard is KABI only by the looks of it.

Do I have to move them to their own header file or can I just #ifdef __KERNEL__ around the place where __ASSEMBLY__ starts to the end of the file?


Alex

