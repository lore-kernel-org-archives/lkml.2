Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897Ab0HLUHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:07:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34656 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab0HLUHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:07:40 -0400
Subject: Re: [PATCH 0/8] v5 De-couple sysfs memory directories from memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg KH <greg@kroah.com>
In-Reply-To: <20100812120816.e97d8b9e.akpm@linux-foundation.org>
References: <4C60407C.2080608@austin.ibm.com>
	 <20100812120816.e97d8b9e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 12 Aug 2010 13:07:03 -0700
Message-ID: <1281643623.6772.78.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 12:08 -0700, Andrew Morton wrote:
> > This set of patches allows for each directory created in sysfs
> > to cover more than one memory section.  The default behavior for
> > sysfs directory creation is the same, in that each directory
> > represents a single memory section.  A new file 'end_phys_index'
> > in each directory contains the physical_id of the last memory
> > section covered by the directory so that users can easily
> > determine the memory section range of a directory.
> 
> What you're proposing appears to be a non-back-compatible
> userspace-visible change.  This is a big issue! 

Nathan, one thought to get around this at the moment would be to bump up
the size that we export in /sys/devices/system/memory/block_size_bytes.
I think you have already done most of the hard work to accomplish
this.  

You can still add the end_phys_index stuff.  But, for now, it would
always be equal to start_phys_index.

-- Dave

