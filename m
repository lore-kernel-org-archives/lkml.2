Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0CXLeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:34:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35471 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754275Ab0CXLeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:34:11 -0400
Date: Wed, 24 Mar 2010 11:37:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
       linuxppc-dev@ozlabs.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 4/7] hvc_console: Fix race between hvc_close and
 hvc_remove
Message-ID: <20100324113721.008d343e@lxorguk.ukuu.org.uk>
In-Reply-To: <1269119079.8599.65.camel@pasglop>
References: <20100319151326.GC8541@kroah.com>
	<1269011916-8836-4-git-send-email-gregkh@suse.de>
	<1269119079.8599.65.camel@pasglop>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010 08:04:39 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Fri, 2010-03-19 at 08:18 -0700, Greg Kroah-Hartman wrote:
> > From: Amit Shah <amit.shah@redhat.com>
> > 
> > Alan pointed out a race in the code where hvc_remove is invoked. The
> > recent virtio_console work is the first user of hvc_remove().
> 
> This causes hangs during boot on pseries machines. Haven't had a chance
> to track that down yet, but please revert
> e74d098c66543d0731de62eb747ccd5b636a6f4c for now.

Its an exploitable hole so we should revert both the bug fix *and* the
submission of the virtio console that makes the flaw triggerable, not jus
tthe security fix.

Alan
