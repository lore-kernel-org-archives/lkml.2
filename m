Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0KCQKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 12:10:35 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:26052 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751861Ab0KCQKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 12:10:32 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 8k8xt9oVM1kygaFYyJJ.uCBODBFUYRiOccGcoDM3KZX31gZ
 .b2PYOCN6ucul85G7HG4FLIgsxcZBgWhBlM6dt1Ar_9BYi0iZeJQHk3ku6vQ
 cJIPV8D0HytbgGxqpzvSIB5AB7UtYv6eZWLXSGqTGTP54SYHfGcsB8AgSKGX
 f1MU54JWt3b63tmsWQl1scr_StKQYXO7DD7OQqA.zFTqxCf.Msn2xP7mMHNO
 iSeTYxUHJxpc2Bc7uSIuZgqxzeoMpHhf6nWNP3mHP_W3oUlmy_mcWV7ZfFX_
 YpE2Zr5qIqA--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 3 Nov 2010 11:10:28 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joe Perches <joe@perches.com>
cc: jovi zhang <bookjovi@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Avoid a memset by using vzalloc
In-Reply-To: <1288799284.15729.27.camel@Joe-Laptop>
Message-ID: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.LNX.2.00.1010302333130.1572@swampdragon.chaosbits.net>  <AANLkTi=nMU3ezNFD8LKBhJxr6CmW6-qHY_Mo3HRt6Os0@mail.gmail.com>  <20101031173336.GA28141@balbir.in.ibm.com>  <alpine.LNX.2.00.1011010639410.31190@swampdragon.chaosbits.net> 
 <alpine.DEB.2.00.1011030937580.10599@router.home>  <AANLkTinhAQ7mNQWtjWCOWEHHwgUf+BynMM7jnVBMG32-@mail.gmail.com> <1288799284.15729.27.camel@Joe-Laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Nov 2010, Joe Perches wrote:

> On Wed, 2010-11-03 at 23:20 +0800, jovi zhang wrote:
> > On Wed, Nov 3, 2010 at 10:38 PM, Christoph Lameter <cl@linux.com> wrote:
> > > On Mon, 1 Nov 2010, Jesper Juhl wrote:
> > >
> > >> On Sun, 31 Oct 2010, Balbir Singh wrote:
> > >
> > >> > > There are so many placed need vzalloc.
> > >> > > Thanks, Jesper.
> > >
> > >
> > > Could we avoid this painful exercise with a "semantic patch"?
>
> There's an existing cocci kmalloc/memset script.

I have it in
/usr/share/doc/coccinelle/examples/janitorings/kzalloc-orig.cocci.gz

(Ubuntu coccinelle package)

> Perhaps this is good enough?
>
> cp scripts/coccinelle/api/alloc/kzalloc-simple.cocci scripts/coccinelle/api/alloc/vzalloc-simple.cocci
> sed -i -e 's/kmalloc/vmalloc/g' -e 's/kzalloc/vzalloc/g' scripts/coccinelle/api/alloc/vzalloc-simple.cocci

Not sure if that is the same script but certainly a good start. Try it and
see if it catches all the locations that you know of?

