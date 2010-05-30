Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0E3DZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 23:25:41 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51516 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab0E3DZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 23:25:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=yDGJoW9xqjxwAcIhvpv90EePFSh4bwJVswassKkbwyjrktFHlu0b02i+rk3SXdW6y0
         L6yrrREI5bJfKQATY7Y6PbdGLJv4X+83Hm/vXV93plPY07ePdRBlJEqSe5IzhcX5wgJp
         R47izrMwdjrvg2ZBa6rJVbZJV3GO5cwKWTBbI=
MIME-Version: 1.0
In-Reply-To: <1275179960.4825.1.camel@gandalf.stny.rr.com>
References: <1274885054-15698-1-git-send-email-xiaosuo@gmail.com> 
	<E1OHw3d-0001yr-Ag@pomaz-ex.szeredi.hu> <AANLkTimzsHAxha3vQxeFn5pF5BmYZ8nLawSG2YU3eujZ@mail.gmail.com> 
	<AANLkTimCXzrXcfwbCy5MZ3D40WBnGbF6Kbj6egTSjk2s@mail.gmail.com> 
	<1275150019.22648.615.camel@gandalf.stny.rr.com> <AANLkTim6tj4OKnLGW2dDIsvAmeU6b9Qsi6IZKdvlKHV2@mail.gmail.com> 
	<1275179960.4825.1.camel@gandalf.stny.rr.com>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sun, 30 May 2010 11:25:19 +0800
Message-ID: <AANLkTilGP6lF61zuG8L6u54g1R2YItrx6df3RWfxvCqf@mail.gmail.com>
Subject: Re: [PATCH v2 3/4]: sendfile: remove flags paramter of 
	do_splice_direct()
To: rostedt@goodmis.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, axboe@kernel.dk,
       Al Viro <viro@zeniv.linux.org.uk>, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 8:39 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Probably because I copied the code from something that used
> SPLICE_F_NONBLOCK ;-)
>

>From the relay API implementation?

> But userspace passes that flag too. Although, maybe I just don't
> understand the API fully.
>

this flag is a little confusing. It is much like:

flags = fcntl(pipe_fd, F_GETFL);
fcntl(pipe_fd, F_SETFL, flags | O_NONBLOCK);
splice(..pipe_fd..., 0); // without O_NONBLOCK
fcntl(pipe_fd, F_SETFL, falgs);

In fact, setting O_NONBLOCK is the only way of letting splice pipe
operations non-blockable currently. When splicing, splice doesn't
refer to the pipe file's f_flags. :(

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
