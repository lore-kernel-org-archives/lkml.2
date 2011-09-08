Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab1IHW4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 18:56:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab1IHWz5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 18:55:57 -0400
MIME-Version: 1.0
In-Reply-To: <87bouv17dc.fsf@tucsk.pomaz.szeredi.hu>
References: <87liu37z3x.fsf@tucsk.pomaz.szeredi.hu> <17416.1315240659@redhat.com>
 <87hb4q9b3r.fsf@tucsk.pomaz.szeredi.hu> <1315281208.3210.26.camel@perseus.themaw.net>
 <87mxeixfaq.fsf@tucsk.pomaz.szeredi.hu> <1315319903.3210.51.camel@perseus.themaw.net>
 <87ipp5y912.fsf@tucsk.pomaz.szeredi.hu> <1315485406.3476.9.camel@perseus.themaw.net>
 <87bouv17dc.fsf@tucsk.pomaz.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Sep 2011 10:42:28 -0700
Message-ID: <CA+55aFy3VN2Y-oadFUMdCaBVQtPT9Ae3fDQCw5vHfA6UvH8GiA@mail.gmail.com>
Subject: Re: [PATCH] vfs: automount should ignore LOOKUP_FOLLOW
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonardo Chiquitto <leonardo.lists@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 8, 2011 at 6:38 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> Yes, 2.6.38 and later kernels do trigger on stat(2) but not on lstat(2).
>
> My question is this:  does this behavior improve anything compared to
> kernels before 2.6.38?  Because I don't see that it does, in fact it's
> just causing regressions.
>
> You say it's a step in the right direction but I don't see why.  Either
> we want stat *and* lstat to both be correct and trigger the automount or
> we are satisfied with the incorrect but well established practice of not
> triggering on (l)stat.
>
> The middle ground makes no sense IMO, there's nothing gained by the
> differentiated behavior based on LOOKUP_FOLLOW.
>
> Can you explain why it's better if stat() tiggers automounts and gives a
> correct result but lstat() doesn't?

I have to say that this is a very cogent question.

The one thing I've not seen in the thread yet is a description of the
failure. What does the regression look like? Just "very slow 'ls' with
some versions of 'ls'" or what?

I'm inclined to apply the patch as a regression fix, but I'll let this
thread try to convince me for another day..

                         Linus
