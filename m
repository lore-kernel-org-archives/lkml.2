Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab2DPV1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:27:25 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:56496 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab2DPV1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:27:23 -0400
Date: Mon, 16 Apr 2012 14:27:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
Message-ID: <20120416212718.GA22824@kroah.com>
References: <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com>
 <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com>
 <20120413105746.10ffb120@stein>
 <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com>
 <20120413190819.9469.qmail@stuge.se>
 <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com>
 <20120416162710.GA24100@kroah.com>
 <CAMP44s1o9kBp8672oBnvna+qH4WpqSqGUsyNpc_C74cfNYcX_g@mail.gmail.com>
 <20120416205856.GA22298@kroah.com>
 <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 12:18:13AM +0300, Felipe Contreras wrote:
> On Mon, Apr 16, 2012 at 11:58 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Apr 16, 2012 at 11:11:05PM +0300, Felipe Contreras wrote:
> >> On Mon, Apr 16, 2012 at 7:27 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> > Just one minor correction in this looney email thread:
> >> >
> >> > On Sat, Apr 14, 2012 at 01:53:22AM +0300, Felipe Contreras wrote:
> >> >> v3.3.x on the other hand are *not* stable. They contain patches
> >> >> backported from v3.4, but nobody guarantees they will work. There was
> >> >> no v3.3.1-rc1, so the first time the patches compromising v3.3.1 were
> >> >> generally tested together is in v3.3.1, at which point if somebody
> >> >> finds issues, it's too late; bad patches are *not* going to be removed
> >> >> in v3.3.2.
> >> >
> >> > Of course there was a 3.3.1-rc1, see the linux-kernel archives for the
> >> > announcemen and the individual patches.  kernel.org has the large patch
> >> > itself if you like that format instead.
> >>
> >> I don't see it here:
> >> http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=tags
> >>
> >> If you really want people to try it, why not tag it?
> >
> > That would be because I don't keep it in that tree.  It is in a quilt
> > tree you can find in the stable-queue.git repo, and I have never tagged
> > -rc1 releases there.  No one has ever asked for it before, so in the
> > past 6 years of stable releases, I guess no one ever needed it.
> >
> > ketchup and tarballs seem to work well for others, perhaps you can use
> > that as well (hint, ketchup on top of the linux-stable tree works just
> > fine for testing this.)
> 
> Perhaps the current process will be continue to be OK, but I do
> believe a tagged v3.3.1-rc1 would have catched the ath9k issue.

How exactly would that have helped here?

You point out:

> I used to compile my own kernels and use your stable tree, but this a
> new laptop and I was using Arch Linux which automatically updated to
> v3.3.1, and with no network I had no way to revert to v3.2.x.
> Fortunately I had the kernel sources available, but I wonder how many
> people were completely stuck.

Arch wouldn't have included a -rc in their kernel (unless they are
crazy), so this would not have helped your situation at all.

So, no, sorry, I'm not going to put -rc kernels in the linux-stable git
tree, they don't fit with our current development flow at this point in
time.

Again, if you want to, you can use ketchup and linux-stable together
quite easily, if you wish to help us with testing.

> If some other 3.x.1 release get broken this way, I would seriously
> consider tagging v3.x.1-rc1 as well. It works for Linus' tree.

"this way" was for a very tiny subset of hardware, so odds are, if this
happens again, it wouldn't be caught this way either.  That subset just
happened to show up in your machine, but, for example, not in the wide
range of hardware I test with here, nor the machines that others test
with.

This thread has gone on long enough, this is it from me, sorry.

greg k-h
