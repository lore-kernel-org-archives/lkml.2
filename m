Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0CQQ7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 12:59:33 -0400
Received: from verein.lst.de ([213.95.11.210]:40022 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab0CQQ7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 12:59:31 -0400
Date: Wed, 17 Mar 2010 17:58:54 +0100
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
Message-ID: <20100317165854.GC29548@lst.de>
References: <4B9DE635.8030208@redhat.com> <20100315080726.GB18054@balbir.in.ibm.com> <4B9DEF81.6020802@redhat.com> <20100315202353.GJ3840@arachsys.com> <4B9F4CBD.3020805@redhat.com> <20100317152452.GZ31148@arachsys.com> <4BA101C5.9040406@redhat.com> <4BA105FE.2000607@redhat.com> <20100317164752.GA31884@arachsys.com> <4BA1090E.9090502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA1090E.9090502@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 17, 2010 at 06:53:34PM +0200, Avi Kivity wrote:
> Meanwhile I looked at the code, and it looks bad.  There is an 
> IO_CMD_FDSYNC, but it isn't tagged, so we have to drain the queue before 
> issuing it.  In any case, qemu doesn't use it as far as I could tell, 
> and even if it did, device-matter doesn't implement the needed 
> ->aio_fsync() operation.

No one implements it, and all surrounding code is dead wood.  It would
require us to do asynchronous pagecache operations, which involve
major surgery of the VM code.  Patches to do this were rejected multiple
times.

