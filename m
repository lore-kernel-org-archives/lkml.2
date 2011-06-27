Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1F0Q5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:57:36 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:48060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1F0Q5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:57:31 -0400
Subject: Re: [PATCH -next] bcma: main.c needs to include <linux/slab.h>
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <4E08B4AA.409@broadcom.com> (sfid-20110627_185027_507290_BCE834F5)
References: <alpine.DEB.2.00.1106261016100.25900@ayla.of.borg>
	 <BANLkTikSLx6FKvF518s99Q8eRU_WF+cn9A@mail.gmail.com>
	 <BANLkTinGvM79fza-=bFwcbtfFzGHAVKJag@mail.gmail.com>
	 <BANLkTikVtWe0jB_jLeP1YZTEKSYA97gdqQ@mail.gmail.com>
	 <4E08B4AA.409@broadcom.com> (sfid-20110627_185027_507290_BCE834F5)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 18:57:24 +0200
Message-ID: <1309193844.3911.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 18:49 +0200, Arend van Spriel wrote:

> > That's why I think it's safe to include linux/slab.h in bcma_private.h.
> > But if that's just my opinion, everybody think it's wrong idea, I'm OK with it.
> 
> My rule of thumb is: Header file a.h may only include header b.h when 
> a.h needs some definition from b.h. Convenience is never a good reason 
> for nested includes.

Yeah, good rule. Consider if you have a.h, b.h and z.c, z.c needs b.h
but not a.h, and now b.h includes a.h ("for convenience") -- changing
a.h would needlessly recompile z.c. Now, changing slab.h will probably
recompile everything anyway, but still...

johannes

