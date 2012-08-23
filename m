Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574Ab2HWSP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 14:15:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:47256 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757421Ab2HWSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 14:15:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,301,1344236400"; 
   d="scan'208";a="190576373"
Date: Thu, 23 Aug 2012 20:26:30 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: use system_nrt_wq instead of custom ones
Message-ID: <20120823182630.GA4771@sortiz-mobl>
References: <20120822232216.GP19212@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822232216.GP19212@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Aug 22, 2012 at 04:22:16PM -0700, Tejun Heo wrote:
> NFC is using a number of custom ordered workqueues w/ WQ_MEM_RECLAIM.
> WQ_MEM_RECLAIM is unnecessary unless NFC is gonna be used as transport
> for storage device, and all use cases match one work item to one
> ordered workqueue - IOW, there's no actual ordering going on at all
> and using system_nrt_wq gives the same behavior.
> 
> There's nothing to be gained by using custom workqueues.  Use
> system_nrt_wq instead and drop all the custom ones.
> 
> Only compile tested.
Tested here, and it works fine.
I'm queueing this one up to my nfc-next branch, thanks a lot for the follow
up.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
