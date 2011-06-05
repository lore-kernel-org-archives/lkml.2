Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab1FEJuq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 05:50:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35446 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1FEJuo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 05:50:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Zvc0DqSZ6B+cadYDyJaqny1YiO5F4j5oJ3QtrHic+vCSil6b22j18dZ6zwuNVLTnkH
         W9F4P1qW9sJwL3rhZeVdrwPfJc9p9xHMOK5MByMl1nJQWep5vzJqDnVq/Zed7mld7+Zk
         ghLRg8bEs5ogf5eRUFqfwR/Z7myMkamb8J4fg=
Date: Sun, 5 Jun 2011 11:50:37 +0200
From: Andre Bartke <andre.bartke@googlemail.com>
To: Connor H <cmdkhh@gmail.com>
Cc: Andre Bartke <andre.bartke@googlemail.com>,
        Michal Nazarewicz <mina86@mina86.com>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/usb/gadget: add missing kfree calls
Message-ID: <20110605115037.56b8983c@kvasir>
In-Reply-To: <BANLkTi=G3gxT0WHham9Yi6SecysGoov68A@mail.gmail.com>
References: <1307216094-13570-1-git-send-email-andre.bartke@gmail.com>
	<op.vwkl82ut3l0zgt@mnazarewicz-glaptop>
	<20110604235449.6a00218c@kvasir>
	<BANLkTi=G3gxT0WHham9Yi6SecysGoov68A@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Jun 2011 18:35:35 -0700
Connor H <cmdkhh@gmail.com> wrote:

> On Sat, Jun 4, 2011 at 2:54 PM, Andre Bartke
> <andre.bartke@googlemail.com> wrote:
> > On Sat, 04 Jun 2011 23:35:16 +0200
> > "Michal Nazarewicz" <mina86@mina86.com> wrote:
> >
> >> On Sat, 04 Jun 2011 21:34:54 +0200, Andre Bartke
> >> <andre.bartke@googlemail.com> wrote:
> >> > diff --git a/drivers/usb/gadget/rndis.c
> >> > b/drivers/usb/gadget/rndis.c @@ -700,6 +701,7 @@ static int
> >> > rndis_reset_response(int configNr, rndis_reset_msg_type *buf)
> >> >     resp->AddressingReset = cpu_to_le32(1);
> >> >     params->resp_avail(params->v);
> >> > +   kfree(r);
> >> >     return 0;
> >> >  }
> >>
> >> Have you tested this?  It does not look right to me.
> >> rndis_add_response() allocates memory and puts the request on a
> >> list.  It is later freed in rndis_free_response().
> >>
> >
> > Nope, the only way I can test this is a build - which it does.
> > You might be right though.
> 
> building != correct
> 
> r is being added to a list in rndis_add_response
> Andre is right, rndis_free_response handles list removal
> 
> 982 if (r && r->buf == buf) {
> 983                         list_del(&r->list);
> 984                         kfree(r);
> 985                 }
> 
> in fact all of the kfree calls I believe are incorrect.
> 
> Connor

alright, then drop this patch please.

> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-kernel" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >

