Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab2CMQe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:34:58 -0400
Received: from cobra.newdream.net ([66.33.216.30]:53974 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2CMQe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=wCdTXRQzoFYxYn6Ri+sPIacoC
	5MSC/LapqRSCfxfbf8K3m8G2rtLzTV22/DSwlKk6Oac43NLCNQ8eeJPPpe5ijx0f
	5DV6nNxdVrxiC53olulpuJ/TJh3NXcgctaQfdqQzALFcr4DZ8CK8ocWoAR84KbKP
	8HFxx8JYlki+i8rmJA=
Date: Tue, 13 Mar 2012 09:34:53 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, ericvh@gmail.com
Subject: Re: [PATCH 06/25] vfs: add i_op->atomic_create()
In-Reply-To: <874nts8uf8.fsf@tucsk.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.1203130932420.10527@cobra.newdream.net>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-7-git-send-email-miklos@szeredi.hu> <20120313093720.GC11797@infradead.org>
 <87lin49259.fsf@tucsk.pomaz.szeredi.hu> <20120313115552.GA21043@infradead.org>
 <87haxs8we3.fsf@tucsk.pomaz.szeredi.hu> <874nts8uf8.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Miklos Szeredi wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > Christoph Hellwig <hch@infradead.org> writes:
> >
> >> On Tue, Mar 13, 2012 at 12:22:10PM +0100, Miklos Szeredi wrote:
> >>> Good point.  Yes, ->create is probably worth getting rid of.  Mkdir, I'm
> >>> not so sure, but I'll look at what filesystems are doing.
> >>
> >> Btw, is there any good reason to keep ->atomic_open and ->atomic_create
> >> separate?  It seems like the instances in general share code anyway.
> >
> > ->atomic_open is called before lookup, ->atomic_create after lookup.
> >
> > How would we differentiate between the two if they were common?  We
> > could have a filesystem flag, but for example CEPH does weird things
> > like using ->atomic_open for !O_CREAT and ->atomic_create for O_CREAT.

Don't let what Ceph used to do distract you; I only got certain intent 
cases to work and didn't bother with the others.

> Or let the filesystem do the lookup in ->atomic_open if it wants (and
> pass the need_lookup flag to the filesystem).

Either way is fine from my perspective.

sage
