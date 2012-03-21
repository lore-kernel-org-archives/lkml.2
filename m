Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab2CUWkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:40:09 -0400
Received: from cs-studio.ru ([195.178.208.66]:47336 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751171Ab2CUWkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:40:07 -0400
Date: Thu, 22 Mar 2012 02:40:02 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [take 3] pohmelfs: call for inclusion
Message-ID: <20120321224001.GB23336@ioremap.net>
References: <1331904553.5406.34.camel@joe2Laptop>
 <20120316134314.GA19342@ioremap.net>
 <1331907127.5406.48.camel@joe2Laptop>
 <20120321202702.GA16713@ioremap.net>
 <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
 <20120321211835.GQ6589@ZenIV.linux.org.uk>
 <20120321213704.GB16713@ioremap.net>
 <20120321215432.GR6589@ZenIV.linux.org.uk>
 <20120321220415.GA22315@ioremap.net>
 <20120321222812.GS6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321222812.GS6589@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 10:28:12PM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> Sigh... I wish it hadn't been an English-speaking maillist; mat is hard to
> translate properly...

Argh, undecency is pretty useful /most of the time/frequently/

> OK, let me try for a printable version: suppose we replace that d_path()
> call with dentry_path() and leave everything else as is; what exactly
> will be broken and how will it break?

I didn't understand you at first. Replacing it with dentry_path() will
not break anything. It was not supposed fs should care about chroot for
this case - every application (including chrooted) writes into own
namespace, so if it changes root, it is on its own...

> > When object was written via remounted path, then it is a problem for
> > those who made a setup - this ugly hack only 'works' in specially
> > crafted environment, which provides its pros and requires fair price of
> > cons.
> 
> _What_ remounted path?  I'm not talking about bindings at all...

I believe you will?

Actually if this useful hack is so much a PITA I will drop it. Or fix
with dentry_path() instead. It doesn't really deserve _that_ much.

-- 
	Evgeniy Polyakov
