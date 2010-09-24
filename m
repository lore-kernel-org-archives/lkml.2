Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830Ab0IXWUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 18:20:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:6089 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771Ab0IXWUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 18:20:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,232,1283756400"; 
   d="scan'208";a="557774094"
Subject: Re: [PATCH RFCv1 1/2] dmaengine: add support for scatterlist to
 scatterlist transfers
From: Dan Williams <dan.j.williams@intel.com>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100924220419.GC24654@ovro.caltech.edu>
References: <1285357571-23377-1-git-send-email-iws@ovro.caltech.edu>
	 <1285357571-23377-2-git-send-email-iws@ovro.caltech.edu>
	 <AANLkTimfZa+N51Tww_pWFqtqMmcYYkH_V0V_P1Qizt5b@mail.gmail.com>
	 <20100924212443.GA24654@ovro.caltech.edu>
	 <1285365194.21375.22.camel@dwillia2-linux>
	 <20100924220419.GC24654@ovro.caltech.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 15:20:14 -0700
Message-ID: <1285366814.21375.30.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 15:04 -0700, Ira W. Snyder wrote:
> On Fri, Sep 24, 2010 at 02:53:14PM -0700, Dan Williams wrote:
> > What about overrun or underrun do we not care if src_total != dst_total?
> > 
> > Otherwise looks ok.
> > 
> 
> I don't know if we should care about that. The algorithm handles that
> case just fine. It copies the maximum amount it can, which is exactly
> min(src_total, dst_total). Whichever scatterlist runs out of entries
> first is the shortest.
> 
> As a real world example, my driver verifies that both scatterlists have
> exactly the right number of bytes available before trying to program the
> hardware.

Ok, just handle the prep failure and I think we are good to go.

--
Dan


