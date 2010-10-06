Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933019Ab0JFSba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:31:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49476 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab0JFSb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:31:29 -0400
Date: Wed, 6 Oct 2010 19:31:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] one writeback regression fix for .36
Message-ID: <20101006183124.GR19804@ZenIV.linux.org.uk>
References: <4CACA9AD.9070900@fusionio.com>
 <AANLkTi=NkzSWR0voR9xLs2f7Rxfc4A_n7qi+t9fbB2iz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=NkzSWR0voR9xLs2f7Rxfc4A_n7qi+t9fbB2iz@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 11:17:54AM -0700, Linus Torvalds wrote:
> > Christoph Hellwig (1):
> > ? ? ?writeback: always use sb->s_bdi for writeback purposes
> 
> This is a f*cking disgrace. It's now the second patch I see during
> this release window that works by parsing random strings in the block
> device layer.
> 
> This needs to stop. There's something seriously wrong in the whole
> subsystem. This kind of hackery is a disease, and it seems to be
> endemic.

Eh...  I'm no fonder of that than you are (and strcmp is fucking stupid),
but... that thing is really sb_is_blkdev_sb() trying to make a comeback
in fs/fs-writeback.c.  IOW, it's sick, but not for the reasons you are
mentioning; strcmp() use is trivially removable.
