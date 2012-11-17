Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779Ab2KQMHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 07:07:30 -0500
Received: from 8bytes.org ([85.214.48.195]:55029 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab2KQMH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 07:07:28 -0500
Date: Sat, 17 Nov 2012 13:07:24 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Shuah Khan <shuah.khan@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kubakici@wp.pl,
        stern@rowland.harvard.edu, Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mark Salter <msalter@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        shuahkhan@gmail.com
Subject: Re: [PATCH] dma-debug: fix to not have dependency on get_dma_ops()
 interface
Message-ID: <20121117120724.GR25742@8bytes.org>
References: <1351983607.2773.9.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351983607.2773.9.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sat Nov 17 13:07:26 2012
X-DSPAM-Confidence: 0.9992
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 50a77dfe22971567396104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 05:00:07PM -0600, Shuah Khan wrote:
> dma-debug depends on get_dma_ops() interface. Several architectures
> do not define dma_ops and get_dma_ops(). When dma debug interfaces are
> used on an architecture (e.g: c6x) that doesn't define get_dmap_ops(),
> compilation fails. Changing dma-debug to call dma_mapping_error() instead
> of defining its own that calls get_dma_ops(), such that the internal use of
> dma_mapping_error() doesn't interfere with the debug_dma_mapping_error()
> interface's mapping error checks. Moving dma_mapping_error() checks in
> check_unmap() under the dma debug entry not found is sufficient to fix the
> problem.
> 
> Reference: https://lkml.org/lkml/2012/10/26/367
> 
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> Reported-by: Mark Salter <msalter@redhat.com>

Sorry for the delay. I applied the patch to the dma-debug branch.


	Joerg


