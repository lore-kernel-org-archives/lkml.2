Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0CXPI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab0CXPIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:08:24 -0400
Date: Wed, 24 Mar 2010 20:35:39 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
	hvc_remove
Message-ID: <20100324150538.GA18581@amit-x200.redhat.com>
References: <20100319151326.GC8541@kroah.com> <1269011916-8836-4-git-send-email-gregkh@suse.de> <1269119079.8599.65.camel@pasglop> <20100324113721.008d343e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324113721.008d343e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) Mar 24 2010 [11:37:21], Alan Cox wrote:
> On Sun, 21 Mar 2010 08:04:39 +1100
> Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
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
> Its an exploitable hole so we should revert both the bug fix *and* the
> submission of the virtio console that makes the flaw triggerable, not jus
> tthe security fix.

If a fix isn't found in reasonable time, I will send a patch that
disables hot-unplug of virtio-console ports.

		Amit
