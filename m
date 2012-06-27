Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2F0AmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 20:42:12 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:41089 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab2F0AmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 20:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120626012751.GB24705@core.coreip.homeip.net>
References: <1339992522-22073-1-git-send-email-djkurtz@chromium.org>
	<1339992522-22073-2-git-send-email-djkurtz@chromium.org>
	<20120621084107.GB2193@core.coreip.homeip.net>
	<20120625081558.GA641@polaris.bitmath.org>
	<CAGS+omD5xp1PeXGMdsz6uP-QL2rU+sfoPBmOPGqi2p8NE9S4Jw@mail.gmail.com>
	<20120626012751.GB24705@core.coreip.homeip.net>
Date: Tue, 26 Jun 2012 17:42:08 -0700
X-Google-Sender-Auth: y8Abkv9y0kErdJZxmQve0aVqWQY
Message-ID: <CANLzEksg2ak9GMOWveMgU+QS-fM92ac-RV+_hNWKZe2gTpsbwQ@mail.gmail.com>
Subject: Re: [PATCH 01/22 v4] Input: atmel_mxt_ts - set phys to i2c client
 adapter name
From: Benson Leung <bleung@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[oops. sorry for duplicate send... resending in plaintext]

Would it more sense to more completely describe the bus type, adapter,
and address in this case, rather than using the client->adapter->name?

Just to give an example from our system, client->adapter->name is
"i915 gmbus panel", so your suggestion would be "i915 gmbus
panel/input0"

How about this instead :
i2c-2-004a/input0

This seems to me more consistent with what is done with USB input
devices, which show a phys field like this :
usb-00:01.2-2.2/input0

Benson

On Mon, Jun 25, 2012 at 6:27 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
>
> On Mon, Jun 25, 2012 at 05:58:46PM +0800, Daniel Kurtz wrote:
> > On Mon, Jun 25, 2012 at 4:15 PM, Henrik Rydberg <rydberg@euromail.se>
> > wrote:
> > >
> > > On Thu, Jun 21, 2012 at 01:41:07AM -0700, Dmitry Torokhov wrote:
> > > > On Mon, Jun 18, 2012 at 12:08:21PM +0800, Daniel Kurtz wrote:
> > > > > This allows userspace to more easily distinguish which bus a
> > > > > particular
> > > > > atmel_mxt_ts device is attached to.
> > > > >
> > > > > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > > > > ---
> > > > >  drivers/input/touchscreen/atmel_mxt_ts.c |    1 +
> > > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > > >
> > > > > diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > > b/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > > index 42e6450..eda9eed 100644
> > > > > --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > > +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> > > > > @@ -1106,6 +1106,7 @@ static int __devinit mxt_probe(struct
> > > > > i2c_client
> > > > > *client,
> > > > >     }
> > > > >
> > > > >     input_dev->name = "Atmel maXTouch Touchscreen";
> > > > > +   input_dev->phys = client->adapter->name;
> > > >
> > > > Normally we set phys to 'xxx/input0' nstead of just the adaptor
> > > > name.
> > >
> > > Daniel, will we be seeing another version of this patch?
> >
> > Yes.  Any guidance on "xxx" ?  atmel_mxt_ts?
>
> What you have before (client->adapter->name) + "/input0" shoudl work
> splendidly.
>
> Thanks.
>
> --
> Dmitry




--
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
