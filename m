Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0LOPwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:52:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753215Ab0LOPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:52:17 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimYpB2iw525_0wGT=sLkCcuy_bAx1QyG8tjRjOb@mail.gmail.com>
References: <1292368360-32216-1-git-send-email-stefani@seibold.net>
 <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
 <AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
 <1292399418.303.8.camel@wall-e> <AANLkTimYpB2iw525_0wGT=sLkCcuy_bAx1QyG8tjRjOb@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Dec 2010 07:51:36 -0800
Message-ID: <AANLkTimbXiu=iXHkE5rnwH9jL5fQ-Z7R2V1kQP2eFGM_@mail.gmail.com>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
To: Pekka Enberg <penberg@kernel.org>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 12:15 AM, Pekka Enberg <penberg@kernel.org> wrote:
>
> I think Linus is after something like this:

That works for me, but I hate the double "switch()" statement checking
the same thing.

Why is the camino() function not just doing something like

 static unsigned int cramino(struct cramfs_inode *ino, unsigned int
dirent_offset)
 {
     unsigned int data_offset = ino->offset;
     return data_offset ? data_offset << 2 : dirent_offset+1;
 }

and we can get rid of all the cruddy CRAMINO_UNIQ() and testing of the
mode entirely for that path.

That, together with Pekka's approach seems nice, simple and clean.

                            Linus
