Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1JBFfv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 01:35:51 -0400
Received: from 1wt.eu ([62.212.114.60]:33361 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821Ab1JBFfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 01:35:46 -0400
Date: Sun, 2 Oct 2011 07:35:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy <akwatts@ymail.com>, schwab@linux-m68k.org, Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20111002053540.GI18690@1wt.eu>
References: <4E8655CD.90107@zytor.com> <20110930235924.GA25176@kroah.com> <20111001141751.GA8937@zeus> <20111001142848.GA27058@kroah.com> <20111001165659.GB18690@1wt.eu> <20111001171916.GA11989@zeus> <20111001175456.GC18690@1wt.eu> <20111001184044.GA13608@zeus> <20111001224313.GH18690@1wt.eu> <4E87AC04.2070405@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E87AC04.2070405@zytor.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Sat, Oct 01, 2011 at 05:10:44PM -0700, H. Peter Anvin wrote:
> On 10/01/2011 03:43 PM, Willy Tarreau wrote:
> > 
> >   <version> <umask> <user> <group> <tag md5> <tar md5> <tar.gz md5> <status>
> > 
> > Since I can attest that I exclusively extracted the tarballs from the
> > tar.gz and dumped their md5 at the same time, I'm pretty sure that the
> > tar.gz's md5 is OK if the tar's md5 is OK. This will help speed up sig
> > checks on mirrors.
> > 
> 
> By the way, it's usually better to use sha256 or something else more
> modern than MD5.

I know but I wanted to use something fast enough on this small
machine. sha256sum is 3.5 times slower than md5sum. Also, we're
not necessarily looking for an issue by which someone would have
spent his time trying to make an md5 collision here ; re-signing
a modified tarball with gpg as root would have been a lower hanging
fruit.

That said, once we know the tarballs are fine, it will not be that
hard to rebuild the sha256 of the compressed tarballs and match them
against existing images.

> > All the times I got a different MD5 between the tarball and the git
> > tag was because of a different user name in the tarball. It seems
> > that old git versions used to use "git/git" instead of "root/root"
> > now.
> 
> Yes, that change was introduced in git-1.5.0-rc1.

I noticed your comment on this in another mail, thanks for the details.

> > This is hardcoded so it's not easy to change it, and I suspect
> > that the tar format might have changed a bit, so if we want to check
> > those MD5s, either we check on old mirrors that are 100% safe, or we
> > have to reinstall an old version of git.
> 
> ... or extract the tarball and diff the contents versus the git tree.

Indeed.

Regards,
Willy

