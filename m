Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1CKBSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 20:18:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:40574 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab1CKBSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 20:18:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,299,1297065600"; 
   d="scan'208";a="718913692"
Date: Thu, 10 Mar 2011 17:18:42 -0800
From: Andi Kleen <ak@linux.intel.com>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
Message-ID: <20110311011842.GA5698@alboin.amr.corp.intel.com>
References: <20110308164508.GA8729@darkside.kls.lan>
 <20110310165730.GC20504@alboin.amr.corp.intel.com>
 <20110310175411.GB25027@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310175411.GB25027@darkside.kls.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Would it be possible to make CPU-affinity configurable for *single*
> kcryptd instances? Either in the way to nail a specific kcryptd to a
> specific CPU or (what would be better for me, I guess) in the way to
> completely remove CPU-affinity from a specific kcryptd, like it was
> before?

I don't think that's a good idea. You probably need to find some way
to make pcrypt (parallel crypt layer) work for dmcrypt. That may
actually give you more speedup too than your old hack because
it can balance over more cores. 

Or get a system with AES-NI -- that usually solves it too.

Frankly I don't think it's a very interesting case, the majority
of workloads are not like that.

-Andi

