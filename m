Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1LGBmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:42:15 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33296 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1LGBmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:42:13 -0500
Date: Tue, 6 Dec 2011 17:42:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Lameter <cl@linux.com>,
        "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>
Subject: Re: [patch v2]numa: add a sysctl to control interleave allocation
 granularity from each node
In-Reply-To: <20111207013754.GA23364@sli10-conroe.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1112061739140.27247@chino.kir.corp.google.com>
References: <1323055846.22361.362.camel@sli10-conroe> <alpine.DEB.2.00.1112061248500.28251@chino.kir.corp.google.com> <20111207013754.GA23364@sli10-conroe.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Dec 2011, Shaohua Li wrote:

> based on the allocation size, right? I did consider it. It would be easy to
> implement this. Note even without my patch we have the issue if allocation
> from one node is big order and small order from other node. And nobody
> complains the imbalance. This makes me think maybe people didn't care
> about the imbalance too much.
> 

Right, I certainly see what you're trying to do and I support it, however, 
if we're going to add a userspace tunable then I think it would be better 
implemented as a size.  You can still get the functionality that you have 
with your patch (just with a size of 0, the default, making every 
allocation on the next node) but can also interleave on PAGE_SIZE, 
HPAGE_SIZE, etc, increments.  I think it would help for users who are 
concerned about node symmetry for contention on the memory bus and it 
would be a shame if someone needed to add a second tunable for that affect 
if your tunable already has applications using it.
