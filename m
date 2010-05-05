Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934396Ab0EEKWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:22:12 -0400
Received: from mail-qy0-f191.google.com ([209.85.221.191]:54404 "EHLO
	mail-qy0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0EEKWK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:22:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GmifQTTcjW9Y98E/vv1QOzm2KAHg5zvCsJ96TGLSCInsoWEce0fzeYVv1oQnpfRsLk
         /Evza+npzug4IDy8kT3HEP5LlEcWLHDq51ciMw4n47fUqeINz9092ekvWbuvVoX9hHQO
         UeBAtMtGfH6i9JbXqbp2ggNTLm+ZP0NC45KHc=
MIME-Version: 1.0
In-Reply-To: <20100505095339.GH30801@buzzloop.caiaq.de>
References: <20100416100126.GI30801@buzzloop.caiaq.de> <4BC8493D.60900@bitsim.com> 
	<20100416112820.GM30801@buzzloop.caiaq.de> <20100416112931.GN30801@buzzloop.caiaq.de> 
	<n2mf17812d71005050045x4359dfeu2f563c3ac0a42223@mail.gmail.com> 
	<20100505080015.GD30801@buzzloop.caiaq.de> <u2nf17812d71005050228x3c19060n9a096d7bcc1db4d6@mail.gmail.com> 
	<20100505094405.GG30801@buzzloop.caiaq.de> <j2tf17812d71005050247ybaf95719l27a9f1f403436b7f@mail.gmail.com> 
	<20100505095339.GH30801@buzzloop.caiaq.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 5 May 2010 18:21:48 +0800
Message-ID: <z2jf17812d71005050321m2520f76cv95801b0539800db5@mail.gmail.com>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
To: Daniel Mack <daniel@caiaq.de>
Cc: Jakob Viketoft <jakob.viketoft@bitsim.com>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 5:53 PM, Daniel Mack <daniel@caiaq.de> wrote:
> On Wed, May 05, 2010 at 05:47:14PM +0800, Eric Miao wrote:
>> On Wed, May 5, 2010 at 5:44 PM, Daniel Mack <daniel@caiaq.de> wrote:
>
>> >> And I'm not able to find
>> >> drivers/pcmcia/pxa2xx_colibri.c as well.
>> >
>> > Erm - how is that related to the patch in question?
>> >
>>
>> The error seems to be (as in previous mail):
>>
>>  CC      drivers/pcmcia/pxa2xx_colibri.o
>> In file included from drivers/pcmcia/pxa2xx_colibri.c:25:
>> arch/arm/mach-pxa/include/mach/colibri.h:13: error: expected ')'
>> before '*' token
>> make[2]: *** [drivers/pcmcia/pxa2xx_colibri.o] Error 1
>> make[1]: *** [drivers/pcmcia] Error 2
>> make: *** [drivers] Error 2
>
> Ah, sorry.
>
>> And actually, inclusion of <mach/mfp.h> is better to be placed where it's
>> used, i.e. drivers/pcmcia/pxa2xx_colibri.c.
>
> In general I agree, but in this case, mfp_t is used in this header file,
> so every piece of code which includes colibri.h will need both
> <mach/mfp.h> and <net/ax88796.h>. And as this is a rule for all users, I
> think the right place for the inclusion is the header file?
>

I see.

Acked-by: Eric Miao <eric.y.miao@gmail.com>


> Apart from that, this fix will work for both mainline and -stable, which
> makes things easier :)
>

I'll take it to -pxa then.

> Daniel
>
>
