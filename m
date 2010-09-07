Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0IGLg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 07:36:57 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56335 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756480Ab0IGLgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 07:36:51 -0400
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
CC: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, bfields@fieldses.org, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
In-reply-to: <m31v95zweh.fsf@linux.vnet.ibm.com>
	(aneesh.kumar@linux.vnet.ibm.com)
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle syscalls
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m31v95zweh.fsf@linux.vnet.ibm.com>
Message-Id: <E1OswT5-000709-U9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 07 Sep 2010 13:36:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Sep 2010, Aneesh Kumar K. V wrote:
> Any update on this. Are you ok with syscall approach which is limitted to
> CAP_DAC_READ_SEARCH  ?

My gut reaction is: "not another bunch of xattr syscalls!".  It
doesn't feel right, this interface is too specialized to warrant a
full set of filesystem syscalls.

Al Viro is right that there are problems with symlinks.  What we
really want here is a sort of symlink that doesn't get followed.  One
way to provide that is to create a kernel internal "handle" filesystem
and direct open_by_handle() to that for anything not a directory or a
regular file.

Thanks,
Miklos
