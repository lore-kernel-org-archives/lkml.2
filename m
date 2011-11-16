Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1KPVwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 16:52:51 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64571 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab1KPVwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 16:52:50 -0500
Date: Wed, 16 Nov 2011 13:52:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Theodore Tso <tytso@mit.edu>
cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] ext4: slab caches set to SLAB_MEM_SPREAD flags.
In-Reply-To: <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
Message-ID: <alpine.DEB.2.00.1111161347000.16596@chino.kir.corp.google.com>
References: <1321455848-1929-1-git-send-email-linkinjeon@gmail.com> <47270FB7-96AC-4F41-98D3-9AD469080DBE@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Nov 2011, Theodore Tso wrote:

> On Nov 16, 2011, at 10:04 AM, Namjae Jeon wrote:
> 
> > If slab caches set to SLAB_MEM_SPREAD flags, The allocation is spread 
> > evenly over all the memory nodes instead of favoring allocation on the 
> > node local to current cpu.
> 
> And why do you think this is a good thing?   For mballoc in particular, 
> the data structures are used immediately and then freed immediately --- 
> on the local node, so using a non-local memory just makes things worse 
> in a NUMA system.
> 

I don't think this has the effect that Namjae thinks it does: this is only 
useful for CONFIG_SLAB and when you have cpusets enabled with 
cpuset.memory_spread_slab set.

To test how useful it is, you should enable CONFIG_SLAB and then mount 
cpusets, set cpuset.memory_spread_slab, and create an MPOL_INTERLEAVE 
mempolicy over all online nodes.  This will have the same effect as adding 
SLAB_MEM_SPREAD to these slab caches (it just doesn't require the 
mempolicy) and will be able to quantify the effects without any changes to 
the kernel at all.
