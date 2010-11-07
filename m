Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0KGRtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 12:49:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52729 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab0KGRtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 12:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IeZWJP8UbWQD8DbY+bGHn+FN/5VM46kzr6ApEpgKZ+h4VyonYPYVDnAoriIMYzn0Rn
         qz9XPUOgEVFaA2OD0n7s5pj4qNUSc6IAqbtS2xl2kkV7OjovMyZ3Gd/2kpVZ7cMZLsN0
         3KK4LobUgyQtC6FCtift2VAUUpCom7g+r8w7Q=
MIME-Version: 1.0
In-Reply-To: <4CD6B7FA.3050005@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
	<4CD6B7FA.3050005@redhat.com>
Date: Sun, 7 Nov 2010 18:49:09 +0100
Message-ID: <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
From: Matt <jackdachef@gmail.com>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        htd@fancy-poultry.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 7, 2010 at 3:30 PM, Milan Broz <mbroz@redhat.com> wrote:
>
> On 11/06/2010 11:16 PM, Matt wrote:
>> before diving into testing out 2.6.37-rc* kernels I wanted to make
>> sure that the patch:
>>
>> [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
>>
>> is safe to use with e.g. >2.6.37-rc1 kernels
>>
>> I know that it's not a "fix all" patch but it significantly seems to
>> speed up my backup jobs (by factor 2-3)
>> and 2.6.37* has evolved that much that interactivity isn't hurt too much
>
> yes, it should work for the simple mappings without problems.
>
> I hope we will fix the patch soon to be ready for upstream.
>
> Milan
>

Hi Milan,

thanks for your answer !

Unfortunately I have to post a "Warning" that it's currently not safe
(at least for me) to use it

a few hours ago before 2.6.37-rc1 was tagged I already had shortly
tested it with the dm-crypt multi-cpu patch and massive "silent" data
corruption or loss occured:

fortunately I don't/didn't see any data-corruption on my /home
partition (yet) but everytime I boot into my system things are screwed
up on the root-partition, e.g.:

where
eselect opengl list would show
>Available OpenGL implementations:
>  [1]   ati *
>  [2]   xorg-x11

normally it's
>cat /etc/env.d/03opengl
># Configuration file for eselect
># This file has been automatically generated.
>LDPATH="/usr/lib32/opengl/ati/lib:/usr/lib64/opengl/ati/lib"
>OPENGL_PROFILE="ati"


it currently says:

>eselect opengl list
>Available OpenGL implementations:
>  [1]   ati
>  [2]   xorg-x11


>cat /etc/env.d/03opengl
># Configuration file for eselect

and another example was a corrupted /etc/init.d/killprocs

so since this (a corrupted killprocs) already had happened in the past
(last time due to a hardlock with fglrx/amd's catalyst driver) I
thought it was some kind of system problem which could be fixed:
I fired up a rebuild-job (emerge -e system) for my system and (surely)
some other stuff disappeared - after 2-3 reboots I wanted to continue
finishing the rebuild and gcc was gone (!)

I don't have the time to re-test everything since this is my testing &
production machine (I'll play back a system-backup tarball) but this
didn't happen (yet) with 2.6.36 and
the following patches related to multi-cpu dm-crypt:

* [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3
* [PATCH] Use generic private pointer in per-cpu struct

so it seems to be safe.

It has to be changes which got introduced with 2.6.37* which broke
stuff. 2.6.36 seems to work perfectly fine with those 2 patches since
several days already

I'll stick with 2.6.36 for some time now

Thanks !

Matt
