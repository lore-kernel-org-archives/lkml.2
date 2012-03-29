Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840Ab2C2CIg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:08:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641Ab2C2CIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:08:31 -0400
Date: Wed, 28 Mar 2012 22:08:20 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
Message-ID: <20120329020820.GB22697@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>, Dave Chinner <david@fromorbit.com>,
	viro@zeniv.linux.org.uk,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	David Rientjes <rientjes@google.com>
References: <20120327155149.d41a235b.akpm@linux-foundation.org>
 <20120328001550.GA3077@redhat.com>
 <20120328043951.GA32741@dastard>
 <20120328164720.d1aea752.akpm@linux-foundation.org>
 <20120329005442.GB16008@redhat.com>
 <20120328181023.274401d1.akpm@linux-foundation.org>
 <1332984523.30775.12.camel@joe2Laptop>
 <20120328184602.e6b11a37.akpm@linux-foundation.org>
 <20120329015059.GA22697@redhat.com>
 <20120328190211.4ac8a653.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328190211.4ac8a653.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 07:02:11PM -0700, Andrew Morton wrote:

 > > Also, what happens if something allocates
 > > and sits on a bunch of vmalloc'd memory ? would we start seeing oom kills ?
 > 
 > vmalloc() would fail.

Ok, that's a pretty boring failure mode, so not a big deal probably.

 > > (thinking of the context of my fuzzing tool where a bunch of instances could
 > >  feasibly call these syscalls and not sit on huge amounts per thread, but
 > >  collectively...  I'm wondering if it could be provoked into killing
 > >  processes I don't own)
 > 
 > umm, if you wanted to deliberately trigger a vmalloc() failure then I
 > guess a good approach would be to locate a vmalloc() site which can
 > persist beyond the syscall (modprobe is a good one!) then exercise it
 > in a way so that there are no N-byte holes left in the arena, then
 > trigger an N-byte vmalloc().

Well modprobe is root-only, so that's not so bad. But it looks like
key_add (see other thread from this evening) and probably others can be
called as a user and gobble up vmalloc space. omnomnom.

	Dave

