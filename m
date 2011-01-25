Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1AYLM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:12:57 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:34245 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1AYLM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:12:56 -0500
Message-ID: <4D3EB02D.6090302@bfs.de>
Date: Tue, 25 Jan 2011 12:12:45 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Julia Lawall <julia@diku.dk>, Vasiliy Kulikov <segooon@gmail.com>,
        Ryan Mallon <ryan@bluewatersys.com>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
References: <1295898922-18822-1-git-send-email-julia@diku.dk> <1295898922-18822-3-git-send-email-julia@diku.dk> <4D3DD964.9020107@bluewatersys.com> <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk> <20110124200515.GA30963@albatros> <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk> <4D3EA6EC.5050305@bfs.de> <20110125104333.GE11507@n2100.arm.linux.org.uk>
In-Reply-To: <20110125104333.GE11507@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 25.01.2011 11:43, schrieb Russell King - ARM Linux:
> On Tue, Jan 25, 2011 at 11:33:16AM +0100, walter harms wrote:
>> Would it be more easy to return NULL in the error case of clk_get() instead
>> of ERR_PTR(-ENOENT) ?
>>
>> So the default could be return NULL and an architecture depending solution
>> replacing that.
> 
> That's not how the API is defined.  The API defines error-pointers to be
> errors, everything should be considered valid.  Please don't go down the
> route of doing something architecturally different from that.
> 
> What if, say, you couldn't return the struct clk because maybe it could
> only be controlled by one user?  Returning an EBUSY error pointer would
> indicate this condition.  What if the module providing the struct clk
> hasn't finished initializing - that's another reason for EBUSY rather
> than ENOENT.
> 
> Error codes are useful to describe why something failed.  NULL pointers
> can't do that.
> 

On Mon, 24 Jan 2011, Vasiliy Kulikov wrote:
> 
...
> clk_get() is defined per-architecture, sometimes it is NULL only.
>

So these is a bug ? They should return -ENOENT ?

The interessting question is: what to do with an error ?

Obviously some architecture can live with NULL, so it is not an critical
error. An the patch shows a code that is simply a return, not even the
user is informed that something did not work as expected.

>From that point of view i would like question if it is useful to have
a "detailed" error instead of just returning NULL.

just my 2 cents,
re,
 wh
