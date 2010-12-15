Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab0LOQbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:31:25 -0500
Received: from www84.your-server.de ([213.133.104.84]:50449 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab0LOQbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:31:24 -0500
Message-ID: <20101215173116.15775s4i0bx8j8es@mail.your-server.de>
Date: Wed, 15 Dec 2010 17:31:16 +0100
From: stefani@seibold.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
References: <1292368360-32216-1-git-send-email-stefani@seibold.net>
 <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
 <AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
 <1292399418.303.8.camel@wall-e>
 <AANLkTimYpB2iw525_0wGT=sLkCcuy_bAx1QyG8tjRjOb@mail.gmail.com>
 <AANLkTimbXiu=iXHkE5rnwH9jL5fQ-Z7R2V1kQP2eFGM_@mail.gmail.com>
In-Reply-To: <AANLkTimbXiu=iXHkE5rnwH9jL5fQ-Z7R2V1kQP2eFGM_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.6)
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Zitat von Linus Torvalds <torvalds@linux-foundation.org>:

> On Wed, Dec 15, 2010 at 12:15 AM, Pekka Enberg <penberg@kernel.org> wrote:
>>
>> I think Linus is after something like this:
>
> That works for me, but I hate the double "switch()" statement checking
> the same thing.
>
> Why is the camino() function not just doing something like
>
>  static unsigned int cramino(struct cramfs_inode *ino, unsigned int
> dirent_offset)
>  {
>      unsigned int data_offset = ino->offset;
>      return data_offset ? data_offset << 2 : dirent_offset+1;
>  }
>
> and we can get rid of all the cruddy CRAMINO_UNIQ() and testing of the
> mode entirely for that path.
>
> That, together with Pekka's approach seems nice, simple and clean.
>
>                             Linus
>

Pekka's approach is not problem. But the "cruddy" CRAMINO_UNIQ() is  
exact what is needed. In your orginal design of cramfs there is no way  
to give entries with no data an unique inode number.

So for not to waste the inode cache and do useless lookups it it  
necessary to distinguish between entries with data and entries with no  
data. The later one need a special handling to create a unique inode  
number depending on the index of the directory entry inside the cramfs  
image.

I try my best to make best out of of the old cramfs design and fix the  
issues of this filesystem.

- Stefani



