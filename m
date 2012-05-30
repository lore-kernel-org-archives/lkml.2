Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2E3Ufb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:35:31 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43243 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab2E3UfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:35:15 -0400
Message-ID: <1338410016.2659.6.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Eric Paris <eparis@parisplace.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mimi Zohar <zohar@us.ibm.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 16:33:36 -0400
In-Reply-To: <20120530202427.GW11775@ZenIV.linux.org.uk>
References: <1337112446.20904.50.camel@falcor>
	 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
	 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
	 <20120516004251.GO22082@ZenIV.linux.org.uk>
	 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
	 <20120516021828.GP22082@ZenIV.linux.org.uk>
	 <1337807899.15138.31.camel@falcor>
	 <20120530043443.GA3200@ZenIV.linux.org.uk>
	 <20120530163605.GV11775@ZenIV.linux.org.uk>
	 <1338406967.2257.24.camel@localhost>
	 <20120530202427.GW11775@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053020-9360-0000-0000-000006D7CABC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 21:24 +0100, Al Viro wrote:
> On Wed, May 30, 2012 at 03:42:47PM -0400, Eric Paris wrote:
> > security_file_mmap() would pretty much only be used in do_mmap_pgoff()
> > (or validate_mmap_request)
> 
> Callers, actually - the whole point is to lift it out of under ->mmap_sem.
> The tricky part is reqprot vs. prot mess.

Linus already addressed it in the original patch, which I split into two
as you suggested:
733559f - "security: move security_file_mmap() and rename to security_mmap_file()" 
b3649e9 security: define and use the new security_mmap_addr() hook

git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.  
 
Mimi


