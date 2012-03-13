Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2CMQnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:43:20 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44778 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab2CMQnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:43:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=qS+xPFw8PkWXYjSkH+wZfPBwH
	6O/riNGIXlH51Y6mKiAAFa5VzQWxhk62U/DZbO10nP+mjcdUc15FHEnOoGR5+7LH
	I8ovmUED6YKRIk14VDUvfZpK21uoBEOV/b1JAPG1nCaLFJfjH18IuUgCg9uHusjC
	jbY/qqdm2fpPROHIko=
Date: Tue, 13 Mar 2012 09:43:15 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, ericvh@gmail.com
Subject: Re: [PATCH 13/25] cifs: implement i_op->atomic_open() and
 i_op->atomic_create()
In-Reply-To: <878vj48vsr.fsf@tucsk.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.1203130936080.10527@cobra.newdream.net>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <1331155362-11132-14-git-send-email-miklos@szeredi.hu> <20120313120649.GB27171@infradead.org>
 <878vj48vsr.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, Miklos Szeredi wrote:
> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Wed, Mar 07, 2012 at 10:22:30PM +0100, Miklos Szeredi wrote:
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >> 
> >> Replace CIFS's ->create operation with ->atomic_open and ->atomic_create.  Also
> >> move the relevant code from ->lookup into the create function.
> >> 
> >> CIFS currently only does atomic open for O_CREAT, but it wants to do that as
> >> early as possible, without first calling ->lookup, so it uses ->atomic_open,
> >> just like NFS.
> >
> > Why does cifs need to set the created flag from inside ->atomic_open?
> >
> > It's different from everyone else in that respect.
> 
> Apparently CIFS is the only one that can tell whether the file was
> created or not.  If the flag is set then notify_create() is called.
> Users of NFS doesn't seem to care, it's of dubious value anyway, but why
> not use the info when available?

It also add MAY_OPEN to acc_mode... I take it that only matters if the 
fs who set created = true looks for it in ->permission()?

+       acc_mode = op->acc_mode;
+       if (created) {
+               fsnotify_create(dir, dentry);
+               acc_mode = MAY_OPEN;
+       }

sage
