Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696Ab2EPWaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:30:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759868Ab2EPWaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:30:17 -0400
Date: Wed, 16 May 2012 18:37:01 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, x86@kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
Message-ID: <20120516213701.GD25397@amt.cnet>
References: <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
 <20120516154940.GA20549@amt.cnet>
 <20120516162247.GA10676@redhat.com>
 <20120516172058.GA22861@amt.cnet>
 <20120516175856.GD10769@redhat.com>
 <20120516181500.GA23791@amt.cnet>
 <20120516182520.GH28798@redhat.com>
 <20120516182948.GF10769@redhat.com>
 <20120516183822.GI28798@redhat.com>
 <20120516190757.GA12113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516190757.GA12113@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 10:07:58PM +0300, Michael S. Tsirkin wrote:
> > not be called in above scenario.
> 
> I think I see. So this shall fix it also makes code cleaner
> (no -2 hack). Right? kvm_apic_has_interrupt is called correct?

Yes, but its used by multiple callsites. Best to unify it (both setting
and clearing) in KVM_REQ_EVENT processing before guest entry.

