Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab0LGIXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:23:53 -0500
Received: from 8bytes.org ([88.198.83.132]:40347 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab0LGIXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:23:51 -0500
Date: Tue, 7 Dec 2010 09:23:50 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] KVM: SVM: Add clean-bit for interrupt state
Message-ID: <20101207082349.GC29502@8bytes.org>
References: <1291373159-4822-1-git-send-email-joerg.roedel@amd.com> <1291373159-4822-6-git-send-email-joerg.roedel@amd.com> <20101206192924.GB13545@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101206192924.GB13545@amt.cnet>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 05:29:24PM -0200, Marcelo Tosatti wrote:
> On Fri, Dec 03, 2010 at 11:45:52AM +0100, Joerg Roedel wrote:
> > This patch implements the clean-bit for all interrupt
> > related state in the vmcb. This corresponds to vmcb offset
> > 0x60-0x67.
> > 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> Don't you have to mark dirty on sync_lapic_to_cr8?

In theory yes, but sync_lapic_to_cr8 is called in every vmexit/vmrun
cycle. Thats why I added the interrupt bit to the always-dirty mask. I
left this as a future optimization to only write cr8 to the vmcb when it
actually changes.

	Joerg

