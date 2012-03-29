Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2C2BvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:51:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422Ab2C2BvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:51:07 -0400
Date: Wed, 28 Mar 2012 21:50:59 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-ID: <20120329015059.GA22697@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
	viro@zeniv.linux.org.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	David Rientjes <rientjes@google.com>
References: <20120313182220.GA11500@redhat.com>
 <20120327155149.d41a235b.akpm@linux-foundation.org>
 <20120328001550.GA3077@redhat.com>
 <20120328043951.GA32741@dastard>
 <20120328164720.d1aea752.akpm@linux-foundation.org>
 <20120329005442.GB16008@redhat.com>
 <20120328181023.274401d1.akpm@linux-foundation.org>
 <1332984523.30775.12.camel@joe2Laptop>
 <20120328184602.e6b11a37.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328184602.e6b11a37.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 06:46:02PM -0700, Andrew Morton wrote:

 > Could.  There was some discussion last year and implementations were
 > tossed around.
 > 
 > I'm a bit apprehensive - kernel code is supposed to be robust, and
 > large allocations are not robust and vmalloc() is crappy.

Can you expand on crappy ?  Also, what happens if something allocates
and sits on a bunch of vmalloc'd memory ? would we start seeing oom kills ?
(thinking of the context of my fuzzing tool where a bunch of instances could
 feasibly call these syscalls and not sit on huge amounts per thread, but
 collectively...  I'm wondering if it could be provoked into killing
 processes I don't own)

	Dave

