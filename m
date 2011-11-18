Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1KRVUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 16:20:35 -0500
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:59322 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755936Ab1KRVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 16:20:34 -0500
Subject: Re: [PATCH] pipe: Fail cleanly when root tries F_SETPIPE_SZ with
 big size
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Pekka Enberg <penberg@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <CAOJsxLG7Q-DEAOXo0SpsBDFRZzFRkRdA4xnP48Khu4QdCrdrWA@mail.gmail.com>
References: <1321646674-26890-1-git-send-email-levinsasha928@gmail.com>
	 <20111118202552.GB2203@ZenIV.linux.org.uk>
	 <CAOJsxLG7Q-DEAOXo0SpsBDFRZzFRkRdA4xnP48Khu4QdCrdrWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 18 Nov 2011 22:20:26 +0100
Message-ID: <1321651226.3420.0.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 23:04 +0200, Pekka Enberg wrote:
> On Fri, Nov 18, 2011 at 10:04:34PM +0200, Sasha Levin wrote:
> >> +     if (nr_pages * sizeof(struct pipe_buffer) > KMALLOC_MAX_SIZE)
> >> +             return -ENOMEM;
> 
> On Fri, Nov 18, 2011 at 10:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > nr_pages is unsigned long, sizeof is greater than 1, KMALLOC_MAX_SIZE is
> > unsigned long...  So write that check as KMALLOC_MAX_SIZE / sizeof > nr_pages
> 
> We could just use __GFP_NOWARN here and let kcalloc() deal with the
> overflow case.

Yep, that would seem the right place to deal with it, IMHO.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


