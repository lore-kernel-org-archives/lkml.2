Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2ECBGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 21:06:20 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42072 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181Ab2ECBGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 21:06:18 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2012 21:06:18 EDT
X-Sasl-enc: Z5mOJ5nIde4eI8JeZWVC5V4fYKtGwPiS4r6KEed5zsVaTR6sew/aJvAsjQ 1336006575
Message-ID: <1336006566.4154.8.camel@perseus.themaw.net>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
From: Ian Kent <raven@themaw.net>
To: Suresh Jayaraman <sjayaraman@suse.com>
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-cifs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 03 May 2012 08:56:06 +0800
In-Reply-To: <20120502135044.6d815e62@tlielax.poochiereds.net>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net>
	 <CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com>
	 <CAH2r5mvd9PFZ5sxC+QLNObX23qWpJkUNdQmS_aqYA++zxueT6w@mail.gmail.com>
	 <4FA11E59.9050004@suse.com>
	 <20120502135044.6d815e62@tlielax.poochiereds.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 13:50 -0400, Jeff Layton wrote:
> On Wed, 02 May 2012 17:15:29 +0530
> Suresh Jayaraman <sjayaraman@suse.com> wrote:
> 
> > On 04/28/2012 09:03 AM, Steve French wrote:
> > > The fix makes sense, but it is fairly recent and I haven't had a
> > > chance to try it,
> > > so unless a new release is imminent, I would prefer to put in the next merge
> > > request (I have at least one more fix likely as well) next week.
> > 
> > We need this fix for -stable as well, right? Please include
> > 
> >    Cc: stable@vger.kernel.org
> > 
> > 
> > Suresh
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> The stable-kernel-rules.txt file says this:
> 
>  - It must fix a real bug that bothers people (not a, "This could be a
>    problem..." type thing).
> 
> ...and...
> 
>  - No "theoretical race condition" issues, unless an explanation of how the
>    race can be exploited is also provided.
> 
> ...and this seems to clearly violate both of those rules. I'd say we
> just go with putting it in 3.4 for now, and keep it in mind if someone
> comes back later and says that it's needed.
> 

I have to agree with Jeff.

I just happened to notice it when trying to work out why DFS automounts
weren't happening.

I eventually found that the kernel in use didn't have the d_invalidate()
patch, then realized the potential problem. It would require fairly
heavy demand to trigger so it isn't urgent, especially since no-one has
actually reported it.

Another reason I should have sent this to Steve, not Linus, sorry for
the noise Linus.

Ian


