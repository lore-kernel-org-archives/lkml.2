Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0LXUuC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 15:50:02 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21257 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab0LXUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 15:50:00 -0500
Date: Fri, 24 Dec 2010 21:40:08 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Andreas Schwab <schwab@linux-m68k.org>
cc: linux-kernel@vger.kernel.org,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: Re: [PATCH][RFC] HPFS: Don't use pointer to out-of-scope array
In-Reply-To: <m2mxnuew8a.fsf@whitebox.home>
Message-ID: <alpine.LNX.2.00.1012242139450.28973@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012242020090.28973@swampdragon.chaosbits.net> <m2mxnuew8a.fsf@whitebox.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Dec 2010, Andreas Schwab wrote:

> Jesper Juhl <jj@chaosbits.net> writes:
> 
> > Secondly I fail to see how this code inside the while loop can even work:
> >
> >   if (hpfs_ea_read(s, a, ano, pos + 4, ea->namelen + 1 + (ea->indirect ? 8 : 0), ex + 4))
> >
> > There is nothing initializing 'ex' which 'ea' points to, so 
> > 'ea->namelen' and 'ea->indirect' are uninitialized.
> 
> The preceding hpfs_ea_read should do it (it reads the first 4 bytes of
> ex which aliases ea->namelen and ea->indirect).
> 
How I managed to miss that I don't know, but I did and you are correct. 
Thanks.


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

