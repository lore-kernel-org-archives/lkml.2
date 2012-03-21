Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab2CUW2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 18:28:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38995 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab2CUW2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 18:28:23 -0400
Date: Wed, 21 Mar 2012 22:28:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [take 3] pohmelfs: call for inclusion
Message-ID: <20120321222812.GS6589@ZenIV.linux.org.uk>
References: <20120316121829.GA12685@ioremap.net>
 <1331904553.5406.34.camel@joe2Laptop>
 <20120316134314.GA19342@ioremap.net>
 <1331907127.5406.48.camel@joe2Laptop>
 <20120321202702.GA16713@ioremap.net>
 <CA+55aFwm+wfMDFwpcngKwrQEeh53JpsDXr9CPU6Xf0mfGvJHKg@mail.gmail.com>
 <20120321211835.GQ6589@ZenIV.linux.org.uk>
 <20120321213704.GB16713@ioremap.net>
 <20120321215432.GR6589@ZenIV.linux.org.uk>
 <20120321220415.GA22315@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321220415.GA22315@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:04:15AM +0400, Evgeniy Polyakov wrote:

> Details are pretty simple - we want to allow external applications to
> get to filesystem and grab data via single requests, since it is
> stateless and can not hold dentry structure. They do not connect to
> server which runs on top of filesystem, but insted directly to storage,
> which hosts raw data.
> 
> Applications know they uploadede data via /whatever/path/was/to/the/file
> And they want to get that data from server via single 'get'. Obviously
> they can not store mapping from all filenames to inode number, and they
> can not request dozen of directory lookups, since it takes time and has
> to maintain state.

Sigh... I wish it hadn't been an English-speaking maillist; mat is hard to
translate properly...

OK, let me try for a printable version: suppose we replace that d_path()
call with dentry_path() and leave everything else as is; what exactly
will be broken and how will it break?

> When object was written via remounted path, then it is a problem for
> those who made a setup - this ugly hack only 'works' in specially
> crafted environment, which provides its pros and requires fair price of
> cons.

_What_ remounted path?  I'm not talking about bindings at all...
