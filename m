Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1HZI6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 04:58:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:56766 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1HZI6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 04:58:31 -0400
Subject: Re: [PATCH 1/2] mm: convert k{un}map_atomic(p, KM_type) to
 k{un}map_atomic(p)
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, linux-arch@vger.kernel.org
Date: Fri, 26 Aug 2011 10:58:16 +0200
In-Reply-To: <1314346676.6486.25.camel@minggr.sh.intel.com>
References: <1314346676.6486.25.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314349096.26922.21.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 16:17 +0800, Lin Ming wrote:
> 
> The KM_type parameter for kmap_atomic/kunmap_atomic is not used anymore
> since commit 3e4d3af(mm: stack based kmap_atomic()).
> 
> So convert k{un}map_atomic(p, KM_type) to k{un}map_atomic(p).
> Most conversion are done by below commands. Some are done by hand.
> 
> find . -type f | xargs sed -i 's/\(kmap_atomic(.*\),\ .*)/\1)/'
> find . -type f | xargs sed -i 's/\(kunmap_atomic(.*\),\ .*)/\1)/'
> 
> Build and tested on 32/64bit x86 kernel(allyesconfig) with 3G memory.
> 
> ARM, MIPS, PowerPc and Sparc are build tested only with
> CONFIG_HIGHMEM=y and CONFIG_HIGHMEM=n.
> I don't have cross-compiler for other arches. 

yet-another-massive patch.. (you're the third or fourth to do so) if
Andrew wants to take this one I won't mind, however previously he didn't
want flag day patches..
