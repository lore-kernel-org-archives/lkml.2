Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab0HTQZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:25:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58242 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab0HTQZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:25:47 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com> <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 09:24:50 -0700
Message-ID: <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 9:07 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That said, it does strike me as rather odd to do VM ops on partial
> stacks. What are you doing, exactly, to hit this?

The reason I ask is that the _sane_ thing to do - if we really care
about this - is to change the 'vm_next' singly-linked list into using
'list.h'. It would clean up a fair amount of stuff, like removing the
need for that disgusting 'find_vma_prev()' thing. There are actually
several users of vma's that want to look at the previous vma, but
because it's hard to get at, they do something non-intuitive or odd.

At the same time, we've had that vm_next pointer since pretty much day
one, and I also get a strong feeling that it's not really worth the
churn.

                         Linus
