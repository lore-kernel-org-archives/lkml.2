Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab0I1IZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:25:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:57843 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab0I1IZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:25:33 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Valerie Aurora <vaurora@redhat.com>
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
Date: Tue, 28 Sep 2010 10:24:59 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Miklos Szeredi <miklos@szeredi.hu>, linuxram@us.ibm.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        neilb@suse.de, viro@zeniv.linux.org.uk
References: <20100920180404.939991832@szeredi.hu> <E1P08oT-0004C7-3O@pomaz-ex.szeredi.hu> <20100927184747.GC8089@shell>
In-Reply-To: <20100927184747.GC8089@shell>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009281025.00727.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 September 2010 20:47:47 Valerie Aurora wrote:
> Maybe I don't understand.  It seems like directories created when the
> file system is *not* union mounted should definitely be merged with
> matching directories on the lower layer.
>
> Take the case of /etc/fstab.  The first union mount never touches /etc
> and it doesn't exist on the topmost layer.  Then we unmount the upper
> layer, mount it somewhere else as a plain mount, and create /etc/ and
> /etc/fstab.  When we union mount it back over the lower layer again,
> we still want the lower layer /etc/ to be merged with the topmost
> /etc/, or else init.d will disappear.

I can't think of a reason why the upper layer would really *need* to be 
modified separately as in this example though, and I'm sure that examples for 
opaqueness by default can be constructed as well.  Transparency comes at a 
cost though (lookup, readdir, whiteouts), and defaulting to opaque directories 
will be more efficient in some cases.  This is why I think that opaqueness by 
default is preferable.

> Again, maybe I'm misunderstanding, but this doesn't make much sense to
> me.  Say I create:
> 
> /upper/a_dir/upper_file
> /lower/a_dir/lower_file
> 
> Then when I union mount them, I want a_dir/ to be transparent
> automatically and show both upper_file and lower_file, without marking
> it manually.

Why?

Thanks,
Andreas
