Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1F2KR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:17:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab1F2KRz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:17:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4E0AF2BA.2040706@gmail.com>
References: <4E0AF2BA.2040706@gmail.com> <1302756608.2854.10.camel@perseus.themaw.net> <BANLkTini-g9XVOohKjwpZT-SGozcwx720A@mail.gmail.com> <4DA4B6A8.7030804@gmail.com> <BANLkTimsAE1ZAJhsSjnh3LqwsN9x0cLaXg@mail.gmail.com> <4DA5DCB8.3040101@gmail.com> <BANLkTineg2XYYOZAU9trrw=+-vH8McN_9w@mail.gmail.com> <4DA5F569.9020309@gmail.com> <BANLkTi=Z1CQm=u2Q1VCHfr=53n5qTC=7bA@mail.gmail.com> <24792.1302808448@redhat.com> 
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: dhowells@redhat.com, Michal Suchanek <hramrach@centrum.cz>,
        Alexander Viro <aviro@redhat.com>, Ian Kent <ikent@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, miklos@szeredi.hu,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: Union mount and overlayfs bake off?
Date: Wed, 29 Jun 2011 11:17:36 +0100
Message-ID: <2477.1309342656@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler <ricwheeler@gmail.com> wrote:

> I think that it has been a while since David reposted the refreshed patch set
> for union mounts & know that overlayfs has recent updates as well.
> 
> Despite that, I have not seen a lot of feedback from reviewers or testers.

The main problem I've got is that it causes lockdep to generate warnings when
the top layer and one of the lower layers are of the same filesystem type.  The
obvious way round this is to give each superblock its own i_mutex lock class
rather than putting this in the file_system_type struct, but I'm not sure of
the consequences (the two obvious problems are superblock transience and the
fact that there may be so many more of them that it may explode lockdep).

I've split out some of the VFS patches that we might be interested in taking
upstream anyway.  They're currently sat on Al's plate for his consideration.

I've been dealing with some of Al's issues with the unionmount patches, but I
know he's got more - I just can't remember them all.

David
