Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab2BPTxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:53:18 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:33721 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab2BPTxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:53:17 -0500
Date: Thu, 16 Feb 2012 21:53:14 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Grant Likely <grant.likely@secretlab.ca>
cc: Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
In-Reply-To: <20120213214623.GJ11077@ponder.secretlab.ca>
Message-ID: <alpine.SOC.1.00.1202162151030.16208@math.ut.ee>
References: <alpine.SOC.1.00.1202130942030.1488@math.ut.ee> <20120213080618.GA11077@ponder.secretlab.ca> <alpine.SOC.1.00.1202131119040.1488@math.ut.ee> <20120213214623.GJ11077@ponder.secretlab.ca>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ugh; that looks bad.  If it failed there, then the global device node list
> is corrupted.  I hate to ask you this, but would you be able to git bisect to
> narrow down the commit that causes the problem?

Finished bisecting on E2500 (the original machine where I found the 
problem). Bisecting leads to
[0ee332c1451869963626bf9cac88f165a90990e1] memblock: Kill early_node_map[]
So yes, it looks like memblock.

-- 
Meelis Roos (mroos@linux.ee)
