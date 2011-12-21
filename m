Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab1LUWdW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:33:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51641 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab1LUWdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:33:19 -0500
Message-ID: <1324506779.17070.23.camel@twins>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Dec 2011 23:32:59 +0100
In-Reply-To: <alpine.DEB.2.02.1112211715350.17283@pianoman.cluster.toy>
References: <20111121145114.049265181@chello.nl>
	   <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu>
	  <1324472337.10752.11.camel@twins>
	  <alpine.DEB.2.02.1112210959540.10098@pianoman.cluster.toy>
	  <alpine.DEB.2.02.1112211622560.16411@pianoman.cluster.toy>
	 <1324503667.17070.7.camel@twins>
	 <alpine.DEB.2.02.1112211715350.17283@pianoman.cluster.toy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 17:19 -0500, Vince Weaver wrote:
> 
> Speaking of bit 48, does your implementation do anything useful about
> the 32/40/48 bit limitation that some processors have with rdpmc?
> Or is the answer that if you might get overflow, then you have to use slow 
> syscall-based read? 

Yeah, we program an overflow interrupt around there (47 bits iirc) and
consume the total into the u64 count value and update the mmap control
page's offset.


