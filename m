Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1LDTKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:10:22 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37615 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab1LDTKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:10:21 -0500
Message-ID: <1323025803.3256.10.camel@lappy>
Subject: Re: [PATCH] KVM: Veirfy memory slot only for readability
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Date: Sun, 04 Dec 2011 21:10:03 +0200
In-Reply-To: <4EDBAF1C.3050308@redhat.com>
References: <1322768576-9242-1-git-send-email-levinsasha928@gmail.com>
	   <4ED826CA.5030502@oss.ntt.co.jp> <4ED84314.5070107@oss.ntt.co.jp>
	  <1322804776.3619.3.camel@lappy> <4EDBA585.2090807@redhat.com>
	 <1323019756.3256.1.camel@lappy> <4EDBAF1C.3050308@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-12-04 at 19:34 +0200, Avi Kivity wrote:
> On 12/04/2011 07:29 PM, Sasha Levin wrote:
> > On Sun, 2011-12-04 at 18:53 +0200, Avi Kivity wrote:
> > > On 12/02/2011 07:46 AM, Sasha Levin wrote:
> > > > > Do you want to create read only memory slots for kvm tool?
> > > >
> > > > What KVM tool currently does is copy the kernel into guest memory and
> > > > run it from there. An idea raised recently was instead of copying it we
> > > > should mmap it into the memory to reduce footprint.
> > > >
> > > > This is why I'm looking into adding a read only memory slot. The KVM
> > > > code doesn't have to know it's read only.
> > > 
> > > The kernel will patch itself very early.  You need to use MAP_PRIVATE
> > > (and thus have a read/write area).  It will be interesting to see what
> > > fraction of the memory is modified.
> > > 
> > > Note that mapping will remove benefits like huge page support, and that
> > > you can get page sharing by using ksm.  Still, it's interesting to see
> > > where this goes.
> >
> > Why would I lose hugepage if the kernel gets it's own memory slot?
> 
> (transparent) hugepages only work on anonymous memory.  Hopefully later
> it will be extended to work on mapped memory as well.

So I'll lose hugepages just for the kernel memory slot, I wonder how it
will matter performance-wise.

-- 

Sasha.

