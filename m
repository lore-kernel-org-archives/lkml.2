Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab2HVOli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:41:38 -0400
Received: from 8bytes.org ([85.214.48.195]:58693 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932429Ab2HVOlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:41:36 -0400
Date: Wed, 22 Aug 2012 16:41:33 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 17/19] x86, msi: Introduce x86_msi.compose_msi_msg
 call-back
Message-ID: <20120822144133.GE16283@8bytes.org>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-18-git-send-email-joerg.roedel@amd.com>
 <20120820140843.GA7732@phenom.dumpdata.com>
 <20120821084007.GL2582@amd.com>
 <20120821144256.GC20097@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821144256.GC20097@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Aug 22 16:41:34 2012
X-DSPAM-Confidence: 0.9993
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5034ef9e22975917413078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 10:42:57AM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 21, 2012 at 10:40:07AM +0200, Joerg Roedel wrote:
> > On Mon, Aug 20, 2012 at 10:08:44AM -0400, Konrad Rzeszutek Wilk wrote:
> > > On Mon, Aug 20, 2012 at 03:56:03PM +0200, Joerg Roedel wrote:
> > > > This call-back points to the right function for initializing
> > > > the msi_msg structure.
> > > 
> > > What is the 'hpet_id' purpose in this?
> > 
> > The VT-d implementation uses it. This function is used to create the MSI
> > message for PCI devices and the HPET. When it is called for the HPET the
> > pdev parameter is NULL and hpet_id is valid.
> 
> Perhaps then a more generic term? 'void *platform_priv' ?

Okay, I looked into the code a bit more and the best solution is to
remove the pdev and hpet_id parameters completly from the
msi_compose_msg path. The only user of these parameters is the Intel
interrupt remapping code which can also set the source-ids in the
irq-alloc path. But this is a larger effort which is best done in a
seperate patch-set.


	Joerg


