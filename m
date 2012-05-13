Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2EMKEa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 06:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2EMKE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 06:04:29 -0400
Date: Sun, 13 May 2012 13:04:26 +0300
From: Gleb Natapov <gleb@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 7/7] kvm: host side for eoi optimization
Message-ID: <20120513100426.GG4296@redhat.com>
References: <cover.1336679924.git.mst@redhat.com>
 <cb4203d10594c055fde1c6fd0b02df1d030fad3b.1336679924.git.mst@redhat.com>
 <20120513093317.GE4296@redhat.com>
 <20120513100127.GB23273@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120513100127.GB23273@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 01:01:28PM +0300, Michael S. Tsirkin wrote:
> > > +	if (eoi_enabled(vcpu))
> > > +		eoi_clr_pending(vcpu);
> > > +	vcpu->arch.eoi.msr_val = data;
> > > +	kvm_gfn_to_hva_cache_init(vcpu->kvm, &vcpu->arch.eoi.data, addr);
> > This may fail.
> 
> On invalid address, yes. Then the cache hva will be set to invalid
> so accesses will fail too. So a malicious guest is only hurting
> itself.
> Maybe add a comment here?
> 
Kill it with #GP like other MSRs do.

--
			Gleb.
