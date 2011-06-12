Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1FLX7n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 19:59:43 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:56491 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754234Ab1FLX7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 19:59:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=PHS00WctM1qKoN96G4XTgIfSRcpPhkkLEx/V3uhPgib2+uJ5R1MkLNnkvfanvswWOuJ5M3Xq3MoEL9SpjqmUzBsSHIwp4MZt/5kQzgzDHxTrncJOev5djkna6HPcCM0p;
Date: Sun, 12 Jun 2011 16:59:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Jean Sacren <sakiwit@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kernel/sched.c: Fix array initialization typo
Message-Id: <20110612165939.04ca68fa.rdunlap@xenotime.net>
In-Reply-To: <20110612230901.GB11580@hexapodia.org>
References: <20110612213107.GA12816@mail.gmail.com>
	<20110612213549.GA21620@p183.telecom.by>
	<20110612220116.GB12311@mail.gmail.com>
	<20110612230901.GB11580@hexapodia.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jun 2011 16:09:01 -0700 Andy Isaacson wrote:

> On Sun, Jun 12, 2011 at 04:01:16PM -0600, Jean Sacren wrote:
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > Date: Mon, 13 Jun 2011 00:35:49 +0300
> > >
> > > On Sun, Jun 12, 2011 at 03:31:07PM -0600, Jean Sacren wrote:
> > > > The fix makes certain so that the size of the initialized arrays doesn't
> > > > go beyond the boundary set by the array size of 40.
> > > 
> > > Why would it possibly do that?
> > 
> > With that ',' comma, doesn't it imply there might be the 41st element in
> > the array?
> 
> No, that's not how C works.
> 
> > Despite the fact that that element is bogus.
> 
> It's not bogus, it's utterly cromulent.  Trailing comma on array
> initializer was mentioned in the original K&R and is explicitly endorsed
> by ISO/IEC 9899:1999 6.7.8 paragraph 1.
> 
> > Further, if the comma is there, what's the benefit? I know you're cool,
> > but is it cool in code that way as well?
> > > 
> > > And it's not a typo.
> > 
> > What is it then?
> 
> It is a standard C idiom for defining array contents.  If you write

ack.  I once worked on on OS where the common idiom for array inits was:

int x[] = {
	1
,	2
,	3
};

so that additions only required one line of change.

> int x[] = {
>     1,
>     2,
>     3
> };
> 
> then when I add a fourth element to your array, I have to modify two
> lines, and the diff will say
> -    3
> +    3,
> +    4
>  };
> 
> whereas if you wrote "3," as the last line of the initializer, the diff
> would be one line long.
> 
> Furthermore, spot the error in this diff:
> 
> @@ -3,4 +3,5 @@ char *x[] = {
>      "quick",
>      "brown",
>      "fox"
> +    "jumped"
>  };



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
