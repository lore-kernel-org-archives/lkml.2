Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798Ab0I1PVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:21:43 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50694 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab0I1PVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:21:42 -0400
Subject: Re: [PATCH 6/8] v2 Update node sysfs code
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Robin Holt <holt@sgi.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org, Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100928092919.GF14068@sgi.com>
References: <4CA0EBEB.1030204@austin.ibm.com>
	 <4CA0F00D.9000702@austin.ibm.com>  <20100928092919.GF14068@sgi.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 28 Sep 2010 08:21:33 -0700
Message-ID: <1285687293.19976.6172.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 04:29 -0500, Robin Holt wrote:
> Also, I don't think I much care for the weirdness that occurs if a
> memory block spans two nodes.  I have not thought through how possible
> (or likely) this is, but the code certainly permits it.  If that were
> the case, how would we know which sections need to be taken offline,
> etc? 

Since the architecture is the one doing the memory_block_size_bytes()
override, I'd expect that the per-arch code knows enough to ensure that
this doesn't happen.  It's probably something to add to the
documentation or the patch descriptions.  "How should an architecture
define this?  When should it be overridden?"

It's just like the question of SECTION_SIZE.  What if a section spans a
node?  Well, they don't because the sections are a software concept and
we _define_ them to not be able to cross nodes.  If they do, just make
them smaller.

-- Dave

