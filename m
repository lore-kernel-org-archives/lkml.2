Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0F2UEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:04:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54138 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958Ab0F2UEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=V71xum5ypyNxaXW+NOgrOxw0tZpCGVR1SyOg3va3vTkk+LBHLR4HufKJm3oApWy050
         /ycQCiwUoXNjx1lAyg6iwBfmhSmwU6cI86jBaCHn+b2zQgMhXe/lqzeLDV0qt1ICIyHB
         GqpdGAWk4ojdQO1vPw4OUIzZCFBL7m73BxjSM=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 02/52] fs: fix superblock iteration race
Date: Tue, 29 Jun 2010 21:04:33 +0100
User-Agent: KMail/1.9.10
Cc: Nick Piggin <npiggin@suse.de>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       Al Viro <viro@zeniv.linux.org.uk>
References: <20100624030212.676457061@suse.de> <AANLkTinr_Ljn48o3YecbuYt15xbP02sbg9D6qqobt1wE@mail.gmail.com> <AANLkTilWhDhzdANZeskV__btrvZuAr-Fhmj7j5iKec-U@mail.gmail.com>
In-Reply-To: <AANLkTilWhDhzdANZeskV__btrvZuAr-Fhmj7j5iKec-U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201006292104.33778.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 June 2010, Linus Torvalds wrote:
> On Tue, Jun 29, 2010 at 10:52 AM, Linus Torvalds
>
> <torvalds@linux-foundation.org> wrote:
> > Look for "2.6.35-rc3 oops trying to suspend" on lkml, for example. No
> > guarantee that it's the same thing, but it's "iterate_supers()"
> > getting an oops [..]
>
> Also, "Oops during closedown with 2.6.35-rc3-git3" is an
> iterate_supers oops (in the jpg) and Chris says it's repeatable for
> him.
>
> Chris - you could try testing current -git now that I've merged Nick's
> patch. It's commit 57439f878af ("fs: fix superblock iteration race"),
> and I just pushed it out (so it might take a few minutes to mirror out
> to the public git trees, but it should be there shortly).
>

Well, it was repeatable this morning, but despite 30+ shutdowns this evening, I 
haven't had a single oops. Perhaps I'm just not doing enough computing stuff 
between startup and shutdown to create the conditions under which I got the 
oopses this morning. Moreover, I've been using this kernel every day with, 
maybe two or three shutdowns a day, for two weeks or so now (since just after 
Linus went on vacation) with no oopses. (The kernel is -rc3 + John 
Fastabend's "net: fix deliver_no_wcard regression on loopback device" patch).

I'll spend a couple of hours doing stuff and see if I can generate an oops. 
Trouble is, of course, that when I pull and build the latest and greatest, I 
won't know why I'm not getting oopses, assuming I don't.

I'll update y'all later.

Chris

>                          Linus



-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
