Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab1FOQPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:15:08 -0400
Received: from mail08-md.ns.itscom.net ([175.177.155.118]:59831 "EHLO
	mail08-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1FOQPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:15:04 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
In-Reply-To: <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu>
References: <20110609125114.8dff08da.akpm@linux-foundation.org> <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk> <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl> <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu>
Date: Thu, 16 Jun 2011 01:14:55 +0900
Message-ID: <15402.1308154495@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> Rollback on failure is an incomplete solution, rollback itself can fail.
> And it doesn't protect against machine crashing in the middle of
> operation.

Maybe you are right.
But do you think rollback is unnecessary since it is an incomplete
solution?

And you might not have read about the approach in aufs, which tries
reducing the operations in rollback.

(from '[RFC 2/8] Aufs2: structure' in 2009
      <http://marc.info/?l=linux-kernel&m=123537453514896&w=2>)
----------------------------------------
In aufs, rmdir(2) and rename(2) for dir uses whiteout alternatively.
In order to make several functions in a single systemcall to be
revertible, aufs adopts an approach to rename a directory to a temporary
unique whiteouted name.
For example, in rename(2) dir where the target dir already existed, aufs
renames the target dir to a temporary unique whiteouted name before the
actual rename on a branch and then handles other actions (make it opaque,
update the attributes, etc). If an error happens in these actions, aufs
simply renames the whiteouted name back and returns an error. If all are
succeeded, aufs registers a function to remove the whiteouted unique
temporary name completely and asynchronously to the system global
workqueue.
----------------------------------------


J. R. Okajima
