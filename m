Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270Ab1KKJFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 04:05:36 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:17035 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757Ab1KKJF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 04:05:29 -0500
From: <oskar.andero@sonyericsson.com>
Date: Fri, 11 Nov 2011 10:06:16 +0100
To: Jonathan Cameron <jic23@kernel.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "aghayal@codeaurora.org" <aghayal@codeaurora.org>,
        "Cavin, Courtney" <Courtney.Cavin@sonyericsson.com>
Subject: Re: [PATCH] input: add driver support for Sharp gp2ap002a00f
 proximity sensor
Message-ID: <20111111090616.GA9307@caracas.corpusers.net>
References: <1320941273-21228-1-git-send-email-oskar.andero@sonyericsson.com>
 <4EBC1668.5040606@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EBC1668.5040606@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Thanks for reviewing!

> ALS sensor in input?  Please see all the previous discussions about
> this.  I'm guessing you are aware of this given you cc'd me though!

Actually, this chip only has a hardwired ALS, meaning nothing is
exposed through the input interfaces.

> Having read driver, this is a proximity switch. Basically it's a button.
> The interface used should reflect this rather than pretending you are
> outputing an ABS value.  Hence this one probably does fit squarely in
> input, but that's for Dmitry to comment on.

Yes, I agree.

> Also, irq fields contain irqs not gpios + the two gpio related pdata
> functions need justification.
> 
> Various small points inline.

> > --- /dev/null
> > +++ b/include/linux/gp2ap002a00f.h
> > @@ -0,0 +1,13 @@
> > +#ifndef _GP2AP002A00F_H_
> > +#define _GP2AP002A00F_H_
> > +
> What is this doing in the header?
> > +#define GP2A_I2C_NAME   "gp2ap002a00f"

This is used for setting up the I2C_BOARD_INFO() in the board file. I
grepped linux/input and found some other drivers doing the same, but if this
is not common practice I can of course move the define to the .c-file.

I'll prepare v2 based on the rest of your comments!

Thanks!

-Oskar
