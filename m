Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab2ITDtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 23:49:45 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35282 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2ITDtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 23:49:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120919203942.GB413@1wt.eu>
References: <1348083460-7920-1-git-send-email-mujeeb.adil@gmail.com>
	<1348083898.2055.8.camel@joe2Laptop>
	<20120919203942.GB413@1wt.eu>
Date: Thu, 20 Sep 2012 09:19:42 +0530
Message-ID: <CANBXnMmuPs7gvT5h4959Pq1aGrCA2jaSdqZnymQGNzJUVXqixg@mail.gmail.com>
Subject: Re: [PATCH] Staging: panel: Fixed a macro coding style issue
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Joe Perches <joe@perches.com>, willy@meta-x.org,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 2:09 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Wed, Sep 19, 2012 at 12:44:58PM -0700, Joe Perches wrote:
>> On Thu, 2012-09-20 at 01:07 +0530, Adil Mujeeb wrote:
>> > Removed do {} while (0) loop for a single statement macros
>> >
>> > Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
>> > ---
>> >  linux-3.6-rc6/drivers/staging/panel/panel.c |    4 ++--
>> >  1 files changed, 2 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/linux-3.6-rc6/drivers/staging/panel/panel.c b/linux-3.6-rc6/drivers/staging/panel/panel.c
>> > index 39f9982..d9fec5b 100644
>> > --- a/linux-3.6-rc6/drivers/staging/panel/panel.c
>> > +++ b/linux-3.6-rc6/drivers/staging/panel/panel.c
>> > @@ -137,8 +137,8 @@
>> >  #define r_ctr(x)        (parport_read_control((x)->port))
>> >  #define r_dtr(x)        (parport_read_data((x)->port))
>> >  #define r_str(x)        (parport_read_status((x)->port))
>> > -#define w_ctr(x, y)     do { parport_write_control((x)->port, (y)); } while (0)
>> > -#define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
>> > +#define w_ctr(x, y)     (parport_write_control((x)->port, (y)))
>> > +#define w_dtr(x, y)     (parport_write_data((x)->port, (y)))
>>
>> Unnecessary parentheses too.
>> It might be better to use static inlines instead.

I just did this change only as per checkpatch script warning. Also the
parentheses is added similar to other macros.
So should i removed all the macros and convert it to static inlines ?

> Agreed. We already got bugs in the cyrix register manipulation for
> years because of the use of macros which caused registers to be set
> in the wrong order, let's not redo that mistake again.

hmmm macros seems too dangerous but does it mean we should not use
macros altogether?
So should i create a single patch which replaces all macros of this
file into inline function?

This is my first effort in submitting a patch :)

PS: I have correct the email id from evel@driverdev.osuosl.org to
devel@driverdev.osuosl.org. My mistake while submitting the patch in
first post :(
>
> Willy
>
