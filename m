Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab0HRI0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:26:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36551 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0HRI0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:26:41 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: miklos@szeredi.hu, jack@suse.cz, agruen@suse.de, viro@zeniv.linux.org.uk,
        jblunck@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu,
        linux-ext4@vger.kernel.org
In-reply-to: <20100817222731.GI5556@shell> (message from Valerie Aurora on
	Tue, 17 Aug 2010 18:27:32 -0400)
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com> <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu> <20100804230421.GC29353@shell> <E1OgyOZ-000321-Fp@pomaz-ex.szeredi.hu> <20100817222731.GI5556@shell>
Message-Id: <E1Oldyc-00062G-Ab@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 18 Aug 2010 10:26:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Valerie Aurora wrote:
> >  - hard links to make sure a separate inode is not necessary for each
> >    whiteout/fallthrough entry
> 
> The problem with hard links is that you run into hard link limits.  I
> don't think we can do hard links for whiteouts and fallthrus.  Each
> whiteout or fallthru will cost an inode if we implement them as
> extended attributes.  This cost has to be balanced against the cost of
> implementing them as dentries, which is mainly code complexity in
> individual file systems.

get_unlinked_inode() is a great idea.  But I feel that individual
inodes for each fallthrough is excessive.  It'll make the first
readdir() really really expensive and wastes a lot of disk and memory
for no good reason.

Not sure how to fix the hard link limits problem though...

Thanks,
Miklos
