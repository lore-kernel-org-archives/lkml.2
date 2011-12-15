Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759460Ab1LOUGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 15:06:46 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:34582 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751400Ab1LOUGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 15:06:45 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX19pe6JFjgVpt4zbYwivn2xV5spyS9LsBCDpQpHbsB
	hJ0+OLGO4Mw7nt
Date: Thu, 15 Dec 2011 21:06:31 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] audit: fix mark refcounting
Message-ID: <20111215200631.GA2379@Neptun>
References: <87obwof06x.fsf@tucsk.pomaz.szeredi.hu>
 <87ipljcjc2.fsf@tucsk.pomaz.szeredi.hu>
 <CA+55aFxuGPj5rhFYt3O1yci_CqHe+Xs8U7WrWOih2W9U73N69w@mail.gmail.com>
 <20111215084050.GQ2203@ZenIV.linux.org.uk>
 <87fwgmjjr9.fsf@tucsk.pomaz.szeredi.hu>
 <87aa6ujjf6.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa6ujjf6.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 10:03:41AM +0100, Miklos Szeredi wrote:
>  
> +	audit_get_parent(parent);
>  	fsnotify_destroy_mark(&parent->mark);
> +	audit_put_parent(parent);

Hi,

What about taking an extra ref on an inode mark in send_to_group()
before we call handle_event()?
So we dont have to handle the cases in which a mark is destroyed
explicitly...

Lino

