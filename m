Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2CXOPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:15:01 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53697
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab2CXOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:14:59 -0400
Date: Sat, 24 Mar 2012 10:14:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com
Subject: Re: [PATCH 06/25] vfs: add i_op->atomic_create()
Message-ID: <20120324141458.GB25980@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-7-git-send-email-miklos@szeredi.hu>
 <20120313093720.GC11797@infradead.org>
 <87lin49259.fsf@tucsk.pomaz.szeredi.hu>
 <20120313115552.GA21043@infradead.org>
 <87haxs8we3.fsf@tucsk.pomaz.szeredi.hu>
 <874nts8uf8.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874nts8uf8.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 03:08:59PM +0100, Miklos Szeredi wrote:
> >> Btw, is there any good reason to keep ->atomic_open and ->atomic_create
> >> separate?  It seems like the instances in general share code anyway.
> >
> > ->atomic_open is called before lookup, ->atomic_create after lookup.
> >
> > How would we differentiate between the two if they were common?  We
> > could have a filesystem flag, but for example CEPH does weird things
> > like using ->atomic_open for !O_CREAT and ->atomic_create for O_CREAT.
> 
> Or let the filesystem do the lookup in ->atomic_open if it wants (and
> pass the need_lookup flag to the filesystem).

That sounds like a much better approch.  And as mentioned by Sarge a lot
of the odd fs behaviour currently probably is because the current atomic
open interface is so awkward that no one really understands it.  We'll
probably be able to clean up a lot of that, but I'd suggest to not try
to cram everything into the initial atomic open support.

