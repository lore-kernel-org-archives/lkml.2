Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab0HTKET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:04:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050Ab0HTKEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:04:15 -0400
Date: Fri, 20 Aug 2010 20:04:01 +1000
From: Neil Brown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        npiggin@suse.de, hooanon05@yahoo.co.jp, bfields@fieldses.org,
        miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 05/13] vfs: Support null pathname in readlink
Message-ID: <20100820200401.1b824be5@notabene>
In-Reply-To: <20100820083213.GB10039@infradead.org>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1282269097-26166-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100820083213.GB10039@infradead.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 04:32:13 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> Changing the interfaces of existing system calls to accept a NULL name
> which previously wasn't acceptable is not valid.  Even for new system
> calls I think it's a bad idea.  utimensat already has the most ugly
> code of all fs related system calls because of that.

Again, you have made an assertion without justifying it.
I disagree, I think it is perfectly valid.

The function would still return an error in every case that it previously
returned an error, because in every previous case the fd would not have
referred to a symlink so the new version will have nothing to perform a
readlink on when NULL is passed.  The error would probably be EINVAL rather
than EFAULT but even that difference could be avoided if it was really
important (I doubt it is).

You only get different behaviour if the path name is NULL and the fd refers
to a symlink.  This is a completely new situation for which there is no
precedent for how the syscall should behave.  We are free to create whatever
behaviour is most consistent.  I believe the proposed behaviour is the
correct one.

The code may be ugly, but I'm sure it can be tidied up, particularly if
several system-calls adopted the same calling convention.

NeilBrown
