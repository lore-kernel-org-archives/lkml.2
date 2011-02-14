Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab1BNS7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:59:39 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37223 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1BNS7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:59:38 -0500
MIME-Version: 1.0
In-Reply-To: <87r5bacvvl.fsf@macbook.be.48ers.dk>
References: <1297699964-20527-1-git-send-email-jacmet@sunsite.dk>
 <AANLkTi=pWV+tfD6YGpKbzTkvLVoLXtGA41QRaaF=VFeq@mail.gmail.com> <87r5bacvvl.fsf@macbook.be.48ers.dk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 14 Feb 2011 11:59:16 -0700
X-Google-Sender-Auth: fFztAWpcVn3AF_mvEhIt7a-8i7s
Message-ID: <AANLkTikri_A1VknD3oLR2LwC4ysOgE20RnqMRdYnHbcP@mail.gmail.com>
Subject: Re: [PATCH] mcp23s08: support mcp23s17 variant
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:29 AM, Peter Korsgaard <jacmet@sunsite.dk> wrote:
>>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:
>
> Hi,
>
>  >> -       return (status < 0) ? status : rx[0];
>  >> +
>  >> +       if (mcp->type == MCP_TYPE_S17) {
>  >> +               tx[1] <<= 1;
>  >> +
>  >> +               status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, 2);
>  >> +               return (status < 0) ? status : (rx[0] | (rx[1] << 8));
>  >> +       } else {
>  >> +               status = spi_write_then_read(mcp->spi, tx, sizeof tx, rx, 1);
>  >> +               return (status < 0) ? status : rx[0];
>  >> +       }
>
>  Grant> Rather than checking ->type for every transaction, would a set of
>  Grant> callbacks for each type be better?  It would probably have lower
>  Grant> overhead and be simpler to maintain.
>
> We could. I didn't do it because the 8bit and 16bit cases are very
> similar, and checking a simple integer is presumably a lot faster than
> the spi access - But I can rework the patch if you insists.

I won't insist, but it really does look like something that should
have separate accessors from a code maintenance perspective.

>
>  >> +++ b/include/linux/spi/mcp23s08.h
>  >> @@ -2,21 +2,24 @@
>  >>  /* FIXME driver should be able to handle IRQs...  */
>  >>
>  >>  struct mcp23s08_chip_info {
>  >> -       bool    is_present;             /* true iff populated */
>  >> -       u8      pullups;                /* BIT(x) means enable pullup x */
>  >> +       bool            is_present;     /* true if populated */
>  >> +       unsigned        pullups;        /* BIT(x) means enable pullup x */
>  >>  };
>
>  Grant> Unrelated whitespace changes.
>
> I wouldn't call it unrelated. It's to ensure it still lines up after the
> s/u8/unsigned/.

Sorry, you're right.  I missed the s/u8/unsigned/ change.  I don't
have any problem with whitespace changes in a hunk that is also
getting a real change.

g.
