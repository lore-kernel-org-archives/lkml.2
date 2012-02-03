Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2BCIZ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:25:28 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:47089 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab2BCIZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:25:27 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=Cufqhujp69hR+MhiHu40yK/USb/hlYs0+irVU46A6+k= c=1 sm=1
 a=-dEdcLQ1GN0A:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=k8hqzbHzjweV03hO1KKrVA==:17 a=xZ5wN_-6ftpR07oayekA:9 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [RFC] killing boilerplate checks in ->link/->mkdir/->rename
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20120202212400.GR23916@ZenIV.linux.org.uk>
Date: Fri, 3 Feb 2012 01:25:26 -0700
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <E950CD52-73DC-404C-A84A-6027CAF7F6E6@dilger.ca>
References: <20120130222717.GA6393@kroah.com> <m18vkoirv9.fsf@fess.ebiederm.org> <4F27C6EB.2070305@suse.cz> <m14nvc82jo.fsf@fess.ebiederm.org> <CA+55aFwZNdoAA9iPMiEp8-+ndgV+CtSZO4neSh_L+gd77k7-vg@mail.gmail.com> <m1wr87ywex.fsf@fess.ebiederm.org> <m1ehueyz20.fsf_-_@fess.ebiederm.org> <CA+55aFyNQnXrL7fWhBt4LYBuoHD_x+j=Af-N=ueFMBkymy9Rnw@mail.gmail.com> <CA+55aFzZX544ZDN9vN3jWMWZ=_9ZtpZ9cR6gNEzUnx9RCqR5LQ@mail.gmail.com> <20120202012258.GQ23916@ZenIV.linux.org.uk> <20120202212400.GR23916@ZenIV.linux.org.uk>
To: Al Viro <viro@zeniv.linux.org.uk>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-02-02, at 2:24 PM, Al Viro wrote:
> FWIW, there's something we really should've done a long time ago: putting
> that limit into sb->s_max_links.  With 0 meaning "leave all checks to
> ->link/->mkdir/->rename".  Something like the following would make a
> reasonable start - just the conversion of obvious cases.  As the next
> step I'd probably initialize it as ~0U instead of 0 and let the filesystems
> that want something trickier (reiserfs, ext4, gfs2, ocfs2) explicitly set
> it to 0 in their foo_fill_super().  That would take care of a bunch of cases
> where we forgot to do those checks (ubifs, hfsplus, jffs2, ramfs, etc.) and
> it's probably a saner default anyway.

This would also give userspace some hope of pathconf(path, _PC_LINK_MAX)
returning the actual value from the filesystem, instead of hard-coding
this into glibc itself based on the statfs-returned f_type magic value.

Cheers, Andreas





