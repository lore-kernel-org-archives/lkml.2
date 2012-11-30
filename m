Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab2K3ECp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 23:02:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57321 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab2K3ECo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 23:02:44 -0500
Date: Fri, 30 Nov 2012 04:02:40 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@parisplace.org>
Cc: Pavel Roskin <proski@gnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        SE-Linux <selinux@tycho.nsa.gov>
Subject: Re: Bisected regression: iterate_fd() selinux change affects flash
 plugin
Message-ID: <20121130040240.GC4939@ZenIV.linux.org.uk>
References: <20121025101416.v1wilj95q8wkk0os-cebfxv@webmail.spamcop.net>
 <20121111235001.a3gqhaijmec0gk0g-cebfxv@webmail.spamcop.net>
 <CACLa4pu4FFwKdoA8ATfmviOj0e0mAQ3U2FNEiJHCv4RfDY4ZoQ@mail.gmail.com>
 <20121112115707.r8h545480kg0cgkk-cebfxv@webmail.spamcop.net>
 <CACLa4pvixB3Ehz-Ds+opvMF73pNwQJxpNx=02qy94ufJag2qwA@mail.gmail.com>
 <20121130034034.GB4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121130034034.GB4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 03:40:34AM +0000, Al Viro wrote:

> The bug is real, but Pavel's patch is all wrong.  The problem is in the
> argument; we should pass descriptor number, not descriptor + 1.  And fixing
> that (in iterator_fd() itself) makes all callbacks work as they ought to.
> 
> PS: Pavel, the life is painful enough as it is, no need to involve BZ into
> it.  Next time you need to post a patch, please do just that, especially
> when it's so short, OK?

See tonight's vfs.git#for-linus; the head is at commit a77cfcb.
