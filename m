Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1FPDH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 23:07:29 -0400
Received: from mail01-md.ns.itscom.net ([175.177.155.111]:38019 "EHLO
	mail01-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1FPDH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 23:07:27 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Erez Zadok <ezk@fsl.cs.sunysb.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>,
        "hramrach@centrum.cz" <hramrach@centrum.cz>,
        "jordipujolp@gmail.com" <jordipujolp@gmail.com>
In-Reply-To: <B723B526-D658-4D22-A9CE-598444148B07@fsl.cs.sunysb.edu>
References: <20110609125114.8dff08da.akpm@linux-foundation.org> <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk> <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl> <803fd88dc28748428861b75afdee3575@HUBCAS1.cs.stonybrook.edu> <B723B526-D658-4D22-A9CE-598444148B07@fsl.cs.sunysb.edu>
Date: Thu, 16 Jun 2011 12:07:19 +0900
Message-ID: <18299.1308193639@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Erez Zadok:
> ...  Asking =
> overlayfs or other stackable file systems to solve this multi-layer =
> coherency perfectly is somewhat ridiculous: we don't expect file systems =
> like ext3 to detect and correctly handle changes to lower devices =97 =
> i.e., if someone hand-edited direct blocks in /dev/sda1, do we?

I agree with you if we discuss about union-type-mount, which handles a
block device as its member. As long as the layered-fs handles a
directory (mounted filesystem) as its member, it is obviously right that
users expect the modification on the member fs (by-passing a union) is
available.

Of course I agree it brings complication to us, and I'd suggest three
level options to support this issue.
- detect the direct changes and reflect it to union (hardest option)
- skip the detection, but verify the parent-child relationship or more
  at least. (this is something like overlayfs is trying to do)
- skip both of the detection and verification (lowest option)
  this option depends how user sets up the union and its member. if user
  hides the members totally by over-mounting an empty dir on the member
  (or something), then he can specify this option. otherwise, this
  option is dangerous. also some symlinks may not work.
  # mkdir /hide
  # mount -o upper=/rw,lower=/ro none /union
  # mount -o bind /hide /rw
  # mount -o bind /hide /ro


J. R. Okajima
