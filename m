Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab0HTQue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:50:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750946Ab0HTQub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <1282322101.12544.25.camel@zakaz.uk.xensource.com>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
 <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
 <1282321974.12544.24.camel@zakaz.uk.xensource.com> <1282322101.12544.25.camel@zakaz.uk.xensource.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 09:49:40 -0700
Message-ID: <AANLkTi=+vwP0kWYKdvVbhSTznfRvHozLmL4YOb=ew=FY@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>, Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 9:35 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
>
> On the other hand the VMA merging is just an optimisation, isn't it?

Well, yes and no. This would make it have semantic differences, if you
were to unmap the lower part of the stack.

I could imagine some crazy program wanting to basically return the
stack pages to the system after doing heavy recursion. IOW, they could
do

 - use lots of stack because we're recursing 1000 levels deep

 - know that we used lots of stack, so after returning do something like

    stack = &local variable;
    align stack down by two pages
    munmap down from there to give memory back

and now it really would be a semantic change where the VM_GROWSDOWN
bit has literally disappeared.

                                  Linus
