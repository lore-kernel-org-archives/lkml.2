Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab0IQRlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:41:00 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:37530 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab0IQRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:40:58 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, miklos@szeredi.hu, hch@infradead.org,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        neilb@suse.de, npiggin@kernel.dk, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V19 00/15] Generic name to handle and open by handle syscalls
In-Reply-To: <E1Ov26Q-0000Hd-IT@pomaz-ex.szeredi.hu>
References: <1282906982-26918-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <m31v95zweh.fsf@linux.vnet.ibm.com> <E1OswT5-000709-U9@pomaz-ex.szeredi.hu> <m3d3spvhdn.fsf@linux.vnet.ibm.com> <E1OsyA1-0007Ct-KS@pomaz-ex.szeredi.hu> <m3r5gyepho.fsf@linux.vnet.ibm.com> <E1Ov26Q-0000Hd-IT@pomaz-ex.szeredi.hu>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 17 Sep 2010 23:10:15 +0530
Message-ID: <m3y6b0s1z4.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010 08:01:18 +0200, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Mon, 13 Sep 2010, Aneesh Kumar K. V wrote:
> > d) we can drop stat, chown and xattr syscall because they are introduced
> >    specially for symlinks as we don't allow open on symlinks.
> > e) It would be nice to have handle based stat syscall to avoid two
> >    syscall overhead for fetching file attributes when implementing a
> >    file server, where fetching file attribute is a common operation. 
> 
> Syscall overhead is generally insignificant compared to other effects.
> The server can also cache open files for commonly used handles.
> 

For some client/server file system an open would require communication to
the server where as we can get stat result based on the values
cached on the client if we support handle based stat.

-aneesh
