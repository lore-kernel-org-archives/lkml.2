Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab0J1SYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 14:24:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:53473 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933933Ab0J1SX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 14:23:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,253,1286175600"; 
   d="scan'208";a="568275987"
Date: Thu, 28 Oct 2010 20:26:10 +0200
From: Andi Kleen <ak@linux.intel.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Mike Anderson <andmike@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>,
        James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Christof Schmitt <christof.schmitt@de.ibm.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, julia@diku.dk
Subject: Re: [ANNOUNCE] Status of unlocked_qcmds=1 operation for .37
Message-ID: <20101028182610.GA4592@gargoyle.fritz.box>
References: <1288132071.8283.689.camel@mulgrave.site>
 <1288132464.5169.112.camel@haakon2.linux-iscsi.org>
 <1288133450.8283.723.camel@mulgrave.site>
 <1288134048.5169.132.camel@haakon2.linux-iscsi.org>
 <1288134713.19649.11.camel@mulgrave.site>
 <1288135918.5169.149.camel@haakon2.linux-iscsi.org>
 <20101027075349.GA32585@gargoyle.fritz.box>
 <1288189658.4692.13.camel@mulgrave.site>
 <20101028091020.GA7906@gargoyle.fritz.box>
 <4CC95BE8.3000909@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC95BE8.3000909@panasas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I disagree with your approach this introduces a spin_unlock_irqrestore
> call site at every return, in the usually huge queuecommand.

I converted the full tree and in practice it turns out there 
are very few returns in nearly all queuecommands. So it won't
make much difference.

Longer term they will be all hopefully gone again anyways.

-Andi
