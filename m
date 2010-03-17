Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab0CQQsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:48:03 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:51043 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab0CQQr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:47:59 -0400
Date: Wed, 17 Mar 2010 16:47:53 +0000
From: Chris Webb <chris@arachsys.com>
To: Avi Kivity <avi@redhat.com>
Cc: balbir@linux.vnet.ibm.com, KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot
 parameter
Message-ID: <20100317164752.GA31884@arachsys.com>
References: <20100315072214.GA18054@balbir.in.ibm.com>
 <4B9DE635.8030208@redhat.com>
 <20100315080726.GB18054@balbir.in.ibm.com>
 <4B9DEF81.6020802@redhat.com>
 <20100315202353.GJ3840@arachsys.com>
 <4B9F4CBD.3020805@redhat.com>
 <20100317152452.GZ31148@arachsys.com>
 <4BA101C5.9040406@redhat.com>
 <4BA105FE.2000607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA105FE.2000607@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> writes:

> Chris, can you carry out an experiment?  Write a program that
> pwrite()s a byte to a file at the same location repeatedly, with the
> file opened using O_SYNC.  Measure the write rate, and run blktrace
> on the host to see what the disk (/dev/sda, not the volume) sees.
> Should be a (write, flush, write, flush) per pwrite pattern or
> similar (for writing the data and a journal block, perhaps even
> three writes will be needed).
> 
> Then scale this across multiple guests, measure and trace again.  If
> we're lucky, the flushes will be coalesced, if not, we need to work
> on it.

Sure, sounds like an excellent plan. I don't have a test machine at the
moment as the last host I was using for this has gone into production, but
I'm due to get another one to install later today or first thing tomorrow
which would be ideal for doing this. I'll follow up with the results once I
have them.

Cheers,

Chris.
