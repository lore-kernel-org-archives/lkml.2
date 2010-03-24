Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0CXK7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab0CXK7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:59:07 -0400
Date: Wed, 24 Mar 2010 16:27:10 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
	hvc_remove
Message-ID: <20100324105710.GD15789@amit-x200.redhat.com>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-4-git-send-email-gregkh@suse.de> <1269119079.8599.65.camel@pasglop> <1269427544.8599.222.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269427544.8599.222.camel@pasglop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) Mar 24 2010 [21:45:44], Benjamin Herrenschmidt wrote:
> On Sun, 2010-03-21 at 08:04 +1100, Benjamin Herrenschmidt wrote:
> > On Fri, 2010-03-19 at 08:18 -0700, Greg Kroah-Hartman wrote:
> > > From: Amit Shah <amit.shah@redhat.com>
> > > 
> > > Alan pointed out a race in the code where hvc_remove is invoked. The
> > > recent virtio_console work is the first user of hvc_remove().
> > 
> > This causes hangs during boot on pseries machines. Haven't had a chance
> > to track that down yet, but please revert
> > e74d098c66543d0731de62eb747ccd5b636a6f4c for now.
> 
> Linus, any chance you can revert that one for now until we figure out
> what's wrong ?

Ben, can you confirm if the lockup you see is also due to the
task_is_waking() issue I found in a kvm guest?

That'll help me debug the issue.

Thanks.

		Amit
