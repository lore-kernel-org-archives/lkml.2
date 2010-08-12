Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab0HLJDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:03:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51004 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0HLJDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:03:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m8qlGf+ipLaN7WGBYKFQa9OQtHoPkkwfxEI4b0NLICaqq7XwFlIBOA47cGmDCKXNxt
         aq5ZqH4sRxgKsCD04fswCrsGPVS8BGIAenAYzhcKOOeTMQ3kOD5bH93O7iLH9/VvMZJt
         smc8pDuYBHknk/5Th+SqU5EoIXtigve6ofWHA=
MIME-Version: 1.0
In-Reply-To: <20100812080701.GB7814@osiris.boeblingen.de.ibm.com>
References: <4C63A551.3040701@in.ibm.com>
	<20100812075532.GA7814@osiris.boeblingen.de.ibm.com>
	<20100812080701.GB7814@osiris.boeblingen.de.ibm.com>
Date: Thu, 12 Aug 2010 11:03:37 +0200
X-Google-Sender-Auth: L2RzmiEulbPsUitepUxxEi13dIo
Message-ID: <AANLkTinnLY4LZ-3xbKEJVR3Qjw5xghRZ6i=tWfw8hJHH@mail.gmail.com>
Subject: Re: Latest git build failure on s390 - dma_get_cache_alignment()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Sachin Sant <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 10:07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On Thu, Aug 12, 2010 at 09:55:32AM +0200, Heiko Carstens wrote:
>> On Thu, Aug 12, 2010 at 01:10:01PM +0530, Sachin Sant wrote:
>> > Latest 2.6.35 git (2.6.35-git11 : 5af568cbd...) fails to build
>> > on s390 with following errors :
>> >
>> > arch/s390/mm/fault.c:396: warning: frame size of 'do_protection_exception' is 264 bytes
>> > In file included from include/linux/dmaengine.h:26,
>> >            from include/linux/skbuff.h:30,
>> >            from include/linux/icmpv6.h:82,
>> >            from include/linux/ipv6.h:220,
>> >            from include/net/ipv6.h:16,
>> >            from include/linux/sunrpc/clnt.h:25,
>> >            from include/linux/nfs_fs.h:48,
>> >            from init/do_mounts.c:20:
>> > include/linux/dma-mapping.h:145: error: static declaration of 'dma_get_cache_alignment' follows non-static declaration
>> > include/asm-generic/dma-mapping-broken.h:73: error: previous declaration of 'dma_get_cache_alignment' was here
>> > make[1]: *** [init/do_mounts.o] Error 1
>> > make[1]: *** Waiting for unfinished jobs....
>> > init/do_mounts_md.c: In function 'md_setup_drive':
>> > init/do_mounts_md.c:241: warning: frame size of 'md_setup_drive' is 496 bytes
>> > make: *** [init] Error 2
>> > make: *** Waiting for unfinished jobs....
>> >
>> > The code in question was last changed via following commit
>> >
>> > commit 4565f0170dfc849b3629c27d769db800467baa62
>> > dma-mapping: unify dma_get_cache_alignment implementations
>>
>> Cc'ing linux-arch since the original patch got posted there as well.

Seems Sun3 suffers from this as well:
http://kisskb.ellerman.id.au/kisskb/buildresult/3022174/

<std_rant>
Funny how these things never show up in linux-next...
</std_rant>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
