Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2GWUW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:22:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40571 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2GWUW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:22:27 -0400
Date: Mon, 23 Jul 2012 21:22:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: st_size of a symlink
Message-ID: <20120723202224.GH31729@ZenIV.linux.org.uk>
References: <500D73FF.1070504@nod.at>
 <alpine.LNX.2.00.1207231959410.1922@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1207231959410.1922@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2012 at 08:09:14PM +0200, Jesper Juhl wrote:
> So, from my point of view it looks like procfs is the one who has got it 
> wrong.
> We should probably fix that (IMVHO).

Fix it _how_?  Try to rename a binary you have running in a process.
Or rename its cwd.  Or rename an opened file.  Watch the corresponding
procfs symlink (still pointing to the swame object) change.  With
no way to tell that some sucker had looked at st_size some time ago
and might get surprised by the change.

The fact is, st_size is just a useful hint for symlink target length.
It tells you the likely sufficient size of buffer.  There's a reason
why readlink(2) returns what it returns; you *can't* rely on the
earlier lstat() results or, for that matter, any prior information.
If nothing else, I could rm that symlink and create a new one in
the meanwhile.  You need to check what it had returned and deal with
insufficient buffer size.  By retrying readlink() with bigger buffer.
With procfs there's just a few more ways the readlink() output can
change, that's all.
