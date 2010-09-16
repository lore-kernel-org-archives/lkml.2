Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab0IPRNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:13:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:53486 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab0IPRNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:13:20 -0400
Subject: Re: [RFC][PATCH] Cross Memory Attach
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
References: <20100915104855.41de3ebf@lilo>
	 <AANLkTimNsDxeyZL4GVaH4L7YGO-EoRyCMHDtMPWU37hN@mail.gmail.com>
	 <1284654451.2275.579.camel@laptop>
	 <AANLkTinihPeUueKhEqUuraW2hcf3FFHjm26RieKQZi0d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Sep 2010 19:13:14 +0200
Message-ID: <1284657194.2275.585.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-16 at 09:54 -0700, Linus Torvalds wrote:
> On Thu, Sep 16, 2010 at 9:27 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-09-15 at 08:11 -0700, Linus Torvalds wrote:
> >
> >>    if (copy_to)
> >>       ret = copy_from_user(..);
> >>    else
> >>       ret = copy_to_user(..);
> >>    kunmap(process_pages[i]);
> >>    if (ret)
> >>       goto out;
> >
> > Shouldn't we be using kmap_atomic()
> 
> Over a copy_to/from_user? Not bloody likely.

Gah, indeed. OK, since its not nested kmap() should indeed work. The
alternative is using get_user_pages() on both address spaces, but I
guess that makes things unnecessarily complex.


