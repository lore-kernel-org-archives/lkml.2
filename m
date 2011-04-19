Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1DSDFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:05:45 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:38246 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab1DSDFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:05:43 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 6/6] overlay: overlay filesystem documentation
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, hramrach@centrum.cz, Miklos Szeredi <mszeredi@suse.cz>
In-Reply-To: <1303142440-26328-7-git-send-email-miklos@szeredi.hu>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu> <1303142440-26328-7-git-send-email-miklos@szeredi.hu>
Date: Tue, 19 Apr 2011 12:05:17 +0900
Message-ID: <7795.1303182317@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Miklos,

Miklos Szeredi:
> +The lower filesystem can be any filesystem supported by Linux and does
> +not need to be writable.  The lower filesystem can even be another
> +overlayfs.  ...

When user mounts overlayfs over and over like this,
# mount -t overlayfs -o upper=/rw1,lower=/ro1 none /ovl1
# mount -t overlayfs -o upper=/rw2,lower=/ovl1 none /ovl2
	:::
# mount -t overlayfs -o upper=/rwN,lower=/ovl{N-1} none /ovlN

And if he modify a file in the bottom RO layer, then overlayfs copies-up
the file into each RW layer?
- 'fileA' exists in only /ro1.
- nested mounts.
- run "echo append >> /ovlN/fileA"
- is fileA copied-up to /rw1, and then to /rw2, and then ... to /rwN?

If user specify a single dir as every upper laery, then the copyup will
be done only once, or such RW layers are not allowed?


J. R. Okajima
