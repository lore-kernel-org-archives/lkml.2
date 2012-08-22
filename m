Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab2HVJNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:13:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab2HVJNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:13:11 -0400
Date: Wed, 22 Aug 2012 10:12:59 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
Message-ID: <20120822091259.GT1448@rhmail.home.annexia.org>
References: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 06:33:45PM -0700, Hugh Dickins wrote:
> Jeff,
> 
> Your commit 91f68c89d8f3 ("block: fix infinite loop in __getblk_slow"),
> already gone into 3.* stable, is not good.  Could you and your testers
> please give this alternative a try - I think it should work, and have
> started it on a few days' memory load on 3.5, but not tried your case.

I'll try your patch later today, but the test is very simple:

- Create a 1024 byte empty (all zeroes) partition and then try to mount it.

Failure was that the mount command would go into an infinite loop
using 100% CPU.  Success is that it gives an error.

More about it here including a very simple libguestfs script to
reproduce it:

  https://bugzilla.redhat.com/show_bug.cgi?id=835019#c0

and a virtual disk image that also demonstrates the problem without
needing anything except a VM running the test kernel:

  https://bugzilla.redhat.com/show_bug.cgi?id=835019#c1

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
