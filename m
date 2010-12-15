Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab0LOQqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:46:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42738 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008Ab0LOQqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:46:21 -0500
MIME-Version: 1.0
In-Reply-To: <20101215173116.15775s4i0bx8j8es@mail.your-server.de>
References: <1292368360-32216-1-git-send-email-stefani@seibold.net>
 <AANLkTi=HaS+wweLaAEcBuRFx+Dr1pKU=One1gOYF55CJ@mail.gmail.com>
 <AANLkTikvN9u3dB_TzNUKjz7g39i+t+h4vt7EVKDLVjLg@mail.gmail.com>
 <1292399418.303.8.camel@wall-e> <AANLkTimYpB2iw525_0wGT=sLkCcuy_bAx1QyG8tjRjOb@mail.gmail.com>
 <AANLkTimbXiu=iXHkE5rnwH9jL5fQ-Z7R2V1kQP2eFGM_@mail.gmail.com> <20101215173116.15775s4i0bx8j8es@mail.your-server.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Dec 2010 08:45:58 -0800
Message-ID: <AANLkTi=6LPBAFu6r75RSYjndCk_P9tDH=bavO3j4c1Rq@mail.gmail.com>
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
To: stefani@seibold.net
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 8:31 AM,  <stefani@seibold.net> wrote:
>
> Pekka's approach is not problem. But the "cruddy" CRAMINO_UNIQ() is exact
> what is needed. In your orginal design of cramfs there is no way to give
> entries with no data an unique inode number.

Umm. And my cramino() did exactly that. If it has a data pointer, it
uses that, otherwise it uses the directory offset.

It just doesn't care about the mode of the file.

(feel free to test the size too, for that matter - that's what the old
code does)

IOW, it uses the old CRAMINO() approach, except instead of "1" for the
non-offset case, it uses "dirent_offset+1"

                   Linus
