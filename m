Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab2GIAjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 20:39:49 -0400
Received: from ozlabs.org ([203.10.76.45]:57998 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2GIAjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 20:39:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback and writethrough
In-Reply-To: <1341471743.18786.12.camel@lappy>
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com> <1341419217.18786.3.camel@lappy> <4FF47023.7080206@redhat.com> <1341436285.18786.6.camel@lappy> <4FF5388C.5010306@redhat.com> <1341471743.18786.12.camel@lappy>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 09 Jul 2012 09:15:11 +0930
Message-ID: <87y5mt3ji0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jul 2012 09:02:23 +0200, Sasha Levin <levinsasha928@gmail.com> wrote:
> On Thu, 2012-07-05 at 08:47 +0200, Paolo Bonzini wrote:
> > Il 04/07/2012 23:11, Sasha Levin ha scritto:
> > > There are two things going on here:
> > >  1. Rename VIRTIO_BLK_F_FLUSH to VIRTIO_BLK_F_WCE
> > >  2. Add a new VIRTIO_BLK_F_CONFIG_WCE
> > > 
> > > I'm concerned that the first change is going to break compilation for
> > > any code that included linux/virtio-blk.h and used VIRTIO_BLK_F_FLUSH.
> > 
> > That would be nlkt, right? :)
> 
> nlkt, lguest, and probably others.
> 
> linux/virtio_blk.h is a public kernel header, which is supposed to be
> used from userspace - so I assume many others who implemented virtio-blk
> for any reason took advantage of that header.

lguest doesn't have an API, so it can be patched.

But if someone else breaks, then yes, we need to define the old name
too.

Cheers,
Rusty.


