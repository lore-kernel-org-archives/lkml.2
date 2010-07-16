Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896Ab0GPSdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:33:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55453 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774Ab0GPSdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:33:33 -0400
Subject: Re: [PATCH 1/5] v2 Split the memory_block structure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C40A3BC.3060504@austin.ibm.com>
References: <4C3F53D1.3090001@austin.ibm.com>
	 <4C3F557F.3000304@austin.ibm.com> <1279300521.9207.222.camel@nimitz>
	 <4C40A3BC.3060504@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 16 Jul 2010 11:33:30 -0700
Message-ID: <1279305210.9207.250.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 13:23 -0500, Nathan Fontenot wrote:
> > If the memory_block's state was inferred to be the same as each
> > memory_block_section, couldn't we just keep a start and end phys_index
> > in the memory_block, and get away from having memory_block_sections at
> > all?
> 
> Oooohhh... I like.  Looking at the code it appears this is possible.  I'll
> try this out and include it in the next version of the patch.
> 
> Do you think we need to add an additional file to each memory block directory
> to indicate the number of memory sections in the memory block that are actually
> present? 

I think it's easiest to just say that each 'memory_block' can only hold
contiguous 'memory_block_sections', and we give either the start/end or
start/length pairs.  It gets a lot more complicated if we have to deal
with lots of holes.

I can just see the hardware designers reading this thread, with their
Dr. Evil laughs trying to come up with a reason to give us a couple of
terabytes of RAM with only every-other 16MB area populated. :)  

-- Dave

