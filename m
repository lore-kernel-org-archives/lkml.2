Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab0IGNAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:00:08 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38775 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756004Ab0IGNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:00:04 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle syscalls
In-Reply-To: <E1OswT5-000709-U9@pomaz-ex.szeredi.hu>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m31v95zweh.fsf@linux.vnet.ibm.com> <E1OswT5-000709-U9@pomaz-ex.szeredi.hu>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Tue, 07 Sep 2010 18:29:48 +0530
Message-ID: <m3d3spvhdn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010 13:36:03 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, 07 Sep 2010, Aneesh Kumar K. V wrote:
> > Any update on this. Are you ok with syscall approach which is limitted to
> > CAP_DAC_READ_SEARCH  ?
> 
> My gut reaction is: "not another bunch of xattr syscalls!".  It
> doesn't feel right, this interface is too specialized to warrant a
> full set of filesystem syscalls.


Are you ok with rest of syscalls other than the handle based xattr one ?
In that case can we get rest of the patches merged and rework xattr patches
later ?. That is xattr support for symlink can follow as a separate patch
series ?


> 
> Al Viro is right that there are problems with symlinks.  What we
> really want here is a sort of symlink that doesn't get followed.  One
> way to provide that is to create a kernel internal "handle" filesystem
> and direct open_by_handle() to that for anything not a directory or a
> regular file.
> 

-aneesh
