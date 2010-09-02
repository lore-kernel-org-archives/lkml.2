Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0IBNcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 09:32:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:47781 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345Ab0IBNcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 09:32:10 -0400
Date: Thu, 2 Sep 2010 23:32:00 +1000
From: Neil Brown <neilb@suse.de>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, vaurora@redhat.com,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100902233200.586fcb31@notabene>
In-Reply-To: <alpine.LNX.2.01.1009021513040.10859@obet.zrqbmnf.qr>
References: <20100826183340.027591901@szeredi.hu>
	<20100827170551.19616048@notabene>
	<E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu>
	<20100827213502.31af4a4c@notabene>
	<E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu>
	<20100829144207.4fbf2713@notabene>
	<E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu>
	<alpine.LNX.2.01.1009021513040.10859@obet.zrqbmnf.qr>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010 15:15:37 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Monday 2010-08-30 12:18, Miklos Szeredi wrote:
> >
> >> My comment about set-theory unions being commutative set me thinking.  I
> >> really don't think "union" is the right name for this thing.  There is
> >> nothing about it which really fits that proper definition of a union.
> >
> >We could call it overlayfs.  People learn new names quickly :)
> 
> There is a much larger issue that you should be very well aware about —
> 
> "The name wanted to be a clever acronym for "Filesystem in
> USErspace", but it turned out to be an unfortunate choice. The author
> has since vowed never to name a project after a common term, not even
> anything found more than a handful of times on Google."
> 
> overlayfs already exists. Right next to fuse on sourceforge...

lol


No, I mean it.  "Linux Over-Lays".  :-)

> 
> 
> Oh and I what I like to see is support for multiple readonly branches :)

I think we very nearly have that, assuming I understand your requirement
correctly.
The lower filesystem can itself be an overlay, providing it is mounted
read-only.

So if /mnt/ro1 /mnt/ro2 /mnt/ro3 are all read-only branches then

 mount -o ro,lowerdir=/mnt/ro1,upperdir=/mnt/ro2 meaninglessstring /mnt/ov1
 mount -o ro,lowerdir=/mnt/ov1,upperdir=/mnt/ro3 meaninglessstring /mnt/ov2
 mount -o lowerdir=/mnt/ov2,upperdir=/mnt/rw ignoreme /mnt/overlay

and /mnt/overlay will be the combination of 3 read-only filesystems and one
writable one.
(this doesn't work with the code as-is, but it is really just a few bug-fixes
away).

NeilBrown
