Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334Ab2C2DAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 23:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049Ab2C2DAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 23:00:13 -0400
Date: Wed, 28 Mar 2012 23:00:00 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-ID: <20120329025959.GA21577@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
	viro@zeniv.linux.org.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	David Rientjes <rientjes@google.com>
References: <20120328043951.GA32741@dastard>
 <20120328164720.d1aea752.akpm@linux-foundation.org>
 <20120329005442.GB16008@redhat.com>
 <20120328181023.274401d1.akpm@linux-foundation.org>
 <1332984523.30775.12.camel@joe2Laptop>
 <20120328184602.e6b11a37.akpm@linux-foundation.org>
 <20120329015059.GA22697@redhat.com>
 <20120328190211.4ac8a653.akpm@linux-foundation.org>
 <20120329020820.GB22697@redhat.com>
 <20120328192804.7326bce9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328192804.7326bce9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 07:28:04PM -0700, Andrew Morton wrote:
 > > But it looks like
 > > key_add (see other thread from this evening) and probably others can be
 > > called as a user and gobble up vmalloc space. omnomnom.
 > 
 > hm, the keys code appears to prevent the user from reserving more than
 > 20000 bytes of memory total (key_payload_reserve()), so it doesn't look
 > very useful for screwing up vmalloc().

Then how did I trick it into trying an order 8 allocation ?

trinity: page allocation failure: order:8, mode:0x40d0
Pid: 27119, comm: trinity Not tainted 3.3.0+ #31
Call Trace:
 [<ffffffff8115dd66>] warn_alloc_failed+0xf6/0x160
 [<ffffffff816ad436>] ? __alloc_pages_direct_compact+0x1d0/0x1e2
 [<ffffffff81162492>] __alloc_pages_nodemask+0x8b2/0xb10
 [<ffffffff8119dae6>] alloc_pages_current+0xb6/0x120
 [<ffffffff8115d3b4>] __get_free_pages+0x14/0x50
 [<ffffffff811ac64f>] kmalloc_order_trace+0x3f/0x1a0
 [<ffffffff811aca0a>] __kmalloc+0x25a/0x280
 [<ffffffff812c034a>] sys_add_key+0x9a/0x210
 [<ffffffff813386be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816c04e9>] system_call_fastpath+0x16/0x1b

