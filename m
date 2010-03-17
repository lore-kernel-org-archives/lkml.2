Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab0CQQxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:53:09 -0400
Received: from verein.lst.de ([213.95.11.210]:37243 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216Ab0CQQxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:53:07 -0400
Date: Wed, 17 Mar 2010 17:52:29 +0100
From: Christoph Hellwig <hch@lst.de>
To: Avi Kivity <avi@redhat.com>
Cc: Chris Webb <chris@arachsys.com>, balbir@linux.vnet.ibm.com,
       KVM development list <kvm@vger.kernel.org>,
       Rik van Riel <riel@surriel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Kevin Wolf <kwolf@redhat.com>
Subject: Re: [PATCH][RF C/T/D] Unmapped page cache control - via boot parameter
Message-ID: <20100317165229.GA29548@lst.de>
References: <20100315072214.GA18054@balbir.in.ibm.com> <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100317152452.GZ31148@arachsys.com> <4BA101C5.9040406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA101C5.9040406@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 06:22:29PM +0200, Avi Kivity wrote:
> They should be reorderable.  Otherwise host filesystems on several 
> volumes would suffer the same problems.

They are reordable, just not as extremly as the the page cache.
Remember that the request queue really is just a relatively small queue
of outstanding I/O, and that is absolutely intentional.  Large scale
_caching_ is done by the VM in the pagecache, with all the usual aging,
pressure, etc algorithms applied to it.  The block devices have a
relatively small fixed size request queue associated with it to
facilitate request merging and limited reordering and having fully
set up I/O requests for the device.

