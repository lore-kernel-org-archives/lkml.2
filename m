Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab0IIUFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 16:05:46 -0400
Received: from mail.perches.com ([173.55.12.10]:1579 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab0IIUFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 16:05:46 -0400
Subject: Re: [rfc patch] treewide: Convert "static const char <*> foo[] ="
 to "static const char <*> const foo[] ="
From: Joe Perches <joe@perches.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTinDTkW9oAG_i30YHc_Ox8ZmWU6YcNouKWYrU=Zr@mail.gmail.com>
References: <1284056536.24986.182.camel@Joe-Laptop>
	 <AANLkTimAuA1oYyoaKsFTPEifdDsz9h=EzTB8gKudyAJk@mail.gmail.com>
	 <1284058127.24986.199.camel@Joe-Laptop>
	 <AANLkTimzAOvP62VnhpSmKoazKkPc30-YTy09g2eYPGBg@mail.gmail.com>
	 <1284060808.24986.231.camel@Joe-Laptop>
	 <AANLkTikm_ROCEZco0UMX47aD28O0EALh=WYfNwSX=fVa@mail.gmail.com>
	 <1284061730.24986.238.camel@Joe-Laptop>
	 <AANLkTinDTkW9oAG_i30YHc_Ox8ZmWU6YcNouKWYrU=Zr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 13:05:44 -0700
Message-ID: <1284062744.24986.244.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 15:50 -0400, Mike Frysinger wrote:
> On Thu, Sep 9, 2010 at 15:48, Joe Perches wrote:
> > On Thu, 2010-09-09 at 15:40 -0400, Mike Frysinger wrote:
> >> On Thu, Sep 9, 2010 at 15:33, Joe Perches wrote:
> >> > On Thu, 2010-09-09 at 15:16 -0400, Mike Frysinger wrote:
> >> >> i dont think you even need to check the contents.  just match the base:
> >> >> char foo[]
> >> >> const char *foo[]
> >> >> we want to catch these even if it isnt static, and catching the
> >> >> forward decl would be useful too.
> >> > I think that's not so good.
> >> > There are times when a default is used but then modified.
> >> > For instance:
> >> > drivers/staging/comedi/drivers/comedi_bond.c:           char file[] = "/dev/comediXXXXXX";
> >> how many hits of non-static (i.e. ones that are extern) that should be
> >> const but arent ?
> > Count them and see.
> you already have the #, so it's easier for you to just give it up.

No, I don't have that #.

To determine it, you'll probably have to convert the
non static/non const char */char [] to [static] const.
Likely it might be easiest to see if the compiler complains
about any modifications of const data.

Good luck, do let me know what you find.

