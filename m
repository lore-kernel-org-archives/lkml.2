Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab0LPJqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 04:46:33 -0500
Received: from www84.your-server.de ([213.133.104.84]:52700 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0LPJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 04:46:32 -0500
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
From: Stefani Seibold <stefani@seibold.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <AANLkTi=6LPBAFu6r75RSYjndCk_P9tDH=bavO3j4c1Rq@mail.gmail.com>
References: <1292368360-32216-1-git-send-email-stefani@seibold.net>
	 <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
	 <AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
	 <1292399418.303.8.camel@wall-e>
	 <AANLkTimYpB2iw525_0wGT=sLkCcuy_bAx1QyG8tjRjOb@mail.gmail.com>
	 <AANLkTimbXiu=iXHkE5rnwH9jL5fQ-Z7R2V1kQP2eFGM_@mail.gmail.com>
	 <20101215173116.15775s4i0bx8j8es@mail.your-server.de>
	 <AANLkTi=6LPBAFu6r75RSYjndCk_P9tDH=bavO3j4c1Rq@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 16 Dec 2010 10:47:22 +0100
Message-ID: <1292492842.3019.5.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 15.12.2010, 08:45 -0800 schrieb Linus Torvalds:
> On Wed, Dec 15, 2010 at 8:31 AM,  <stefani@seibold.net> wrote:
> >
> > Pekka's approach is not problem. But the "cruddy" CRAMINO_UNIQ() is exact
> > what is needed. In your orginal design of cramfs there is no way to give
> > entries with no data an unique inode number.
> 
> Umm. And my cramino() did exactly that. If it has a data pointer, it
> uses that, otherwise it uses the directory offset.
> 

The current implementation does it not.

> It just doesn't care about the mode of the file.
> 

Right, but there are a buggy cramfs tools (which can create images for
different endian target or create on the fly devices nodes and so on)
out there, which set the offset of the cramfs_inode to a value not equal
0. This works well with older kernel like 2.6.12 but during the
evolution of the kernel this was broken.

I will resend a cleaned up patch. Hope you will apply it ;-)

Stefani


