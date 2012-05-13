Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab2EMQV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 12:21:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33411 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753608Ab2EMQV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 12:21:58 -0400
Message-ID: <1336926115.2656.2.camel@joe2Laptop>
Subject: Re: [PATCH 2/2] fat: use fat_msg_ratelimit in fat__get_entry.
From: Joe Perches <joe@perches.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Date: Sun, 13 May 2012 09:21:55 -0700
In-Reply-To: <87bolsdpzk.fsf@devron.myhome.or.jp>
References: <1336907039-18638-1-git-send-email-linkinjeon@gmail.com>
	 <1336924011.31383.6.camel@joe2Laptop> <87bolsdpzk.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 01:07 +0900, OGAWA Hirofumi wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > On Sun, 2012-05-13 at 07:03 -0400, Namjae Jeon wrote:
> >> So this patch use fat_msg_ratelimit function about this message to decrease this messages.
> > []
> >> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> >> index aca191b..b2cdbf4 100644
> >> --- a/fs/fat/dir.c
> >> +++ b/fs/fat/dir.c
> >> @@ -98,8 +98,8 @@ next:
> >>  
> >>  	*bh = sb_bread(sb, phys);
> >>  	if (*bh == NULL) {
> >> -		fat_msg(sb, KERN_ERR, "Directory bread(block %llu) failed",
> >> -		       (llu)phys);
> >> +		fat_msg_ratelimit(sb, KERN_ERR, "Directory bread(block %llu) "
> >> +				"failed", (llu)phys);
> >
> > Please don't split format strings.
> > It's much harder to grep.
> 
> Please fight with 80 columns guys before requesting it.

That battle is long over.

from Documentation/CodingStyle:

		Chapter 2: Breaking long lines and strings

[]

The limit on the length of lines is 80 columns and this is a strongly
preferred limit.
[]
However, never break user-visible strings such as
printk messages, because that breaks the ability to grep for them.


