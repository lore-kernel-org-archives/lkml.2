Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1FEBfk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 21:35:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45306 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361Ab1FEBfg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 21:35:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vaIK+4IOLKmUP+sW2pa6HdvTLLZxPO6OT2cvtN/J9woDapqaEqytksBFu4KEfMOPnA
         8UcAecgvIbBNUTJqxD+cGS7kKwKjA0UGJgvRykSlsw9o60ph+LKgp30VNlDI1i3fHqWt
         i4kVqf0j4l7YO6AM/pQ5g0wdx+7ab3kMz+A5c=
MIME-Version: 1.0
In-Reply-To: <20110604235449.6a00218c@kvasir>
References: <1307216094-13570-1-git-send-email-andre.bartke@gmail.com>
	<op.vwkl82ut3l0zgt@mnazarewicz-glaptop>
	<20110604235449.6a00218c@kvasir>
Date: Sat, 4 Jun 2011 18:35:35 -0700
Message-ID: <BANLkTi=G3gxT0WHham9Yi6SecysGoov68A@mail.gmail.com>
Subject: Re: [PATCH] drivers/usb/gadget: add missing kfree calls
From: Connor H <cmdkhh@gmail.com>
To: Andre Bartke <andre.bartke@googlemail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 4, 2011 at 2:54 PM, Andre Bartke
<andre.bartke@googlemail.com> wrote:
> On Sat, 04 Jun 2011 23:35:16 +0200
> "Michal Nazarewicz" <mina86@mina86.com> wrote:
>
>> On Sat, 04 Jun 2011 21:34:54 +0200, Andre Bartke
>> <andre.bartke@googlemail.com> wrote:
>> > diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
>> > @@ -700,6 +701,7 @@ static int rndis_reset_response(int configNr,
>> > rndis_reset_msg_type *buf)
>> >     resp->AddressingReset = cpu_to_le32(1);
>> >     params->resp_avail(params->v);
>> > +   kfree(r);
>> >     return 0;
>> >  }
>>
>> Have you tested this?  It does not look right to me.
>> rndis_add_response() allocates memory and puts the request on a
>> list.  It is later freed in rndis_free_response().
>>
>
> Nope, the only way I can test this is a build - which it does.
> You might be right though.

building != correct

r is being added to a list in rndis_add_response
Andre is right, rndis_free_response handles list removal

982 if (r && r->buf == buf) {
983                         list_del(&r->list);
984                         kfree(r);
985                 }

in fact all of the kfree calls I believe are incorrect.

Connor

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
