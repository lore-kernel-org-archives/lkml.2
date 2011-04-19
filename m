Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab1DSD6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 23:58:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab1DSD6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 23:58:30 -0400
Date: Tue, 19 Apr 2011 13:58:18 +1000
From: NeilBrown <neilb@suse.de>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 6/6] overlay: overlay filesystem documentation
Message-ID: <20110419135818.024cd289@notabene.brown>
In-Reply-To: <7795.1303182317@jrobl>
References: <1303142440-26328-1-git-send-email-miklos@szeredi.hu>
	<1303142440-26328-7-git-send-email-miklos@szeredi.hu>
	<7795.1303182317@jrobl>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 12:05:17 +0900 "J. R. Okajima" <hooanon05@yahoo.co.jp>
wrote:

> 
> Hello Miklos,
> 
> Miklos Szeredi:
> > +The lower filesystem can be any filesystem supported by Linux and does
> > +not need to be writable.  The lower filesystem can even be another
> > +overlayfs.  ...
> 
> When user mounts overlayfs over and over like this,
> # mount -t overlayfs -o upper=/rw1,lower=/ro1 none /ovl1
> # mount -t overlayfs -o upper=/rw2,lower=/ovl1 none /ovl2
> 	:::
> # mount -t overlayfs -o upper=/rwN,lower=/ovl{N-1} none /ovlN
> 
> And if he modify a file in the bottom RO layer, then overlayfs copies-up
> the file into each RW layer?
> - 'fileA' exists in only /ro1.
> - nested mounts.
> - run "echo append >> /ovlN/fileA"
> - is fileA copied-up to /rw1, and then to /rw2, and then ... to /rwN?
> 
> If user specify a single dir as every upper laery, then the copyup will
> be done only once, or such RW layers are not allowed?
> 
> 
> J. R. Okajima

Only to top level of an overlay stack is writable.  All others are or should
be read only.  So only the top level can change.

So in your example, fileA will be copied from ro1 directly into rwN where it
will then be appended to.

NeilBrown
