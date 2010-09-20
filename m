Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0ITHmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:42:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52377 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0ITHmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=OpdkSaLWIZddf5p0xR4KSeNn6Cwss5AKPY/iBa6Jc6qEFEDU1wg/f3nUx/knRP5Anf
         8tAY/NyeRS9Nb+4T2Wy+ditZzZ4WrlMHILGf3jvd1pz4E8tzfojozFeSPHEoHiy7AFa4
         uoVPO3Myn3dqeSzDnCDv8CStT9IIVy4bGl6Cg=
MIME-Version: 1.0
In-Reply-To: <4C8F0CF8.1050309@cs.helsinki.fi>
References: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com>
	<alpine.DEB.2.00.1009130855430.26275@router.home>
	<4C8F0CF8.1050309@cs.helsinki.fi>
Date: Mon, 20 Sep 2010 10:42:16 +0300
X-Google-Sender-Auth: xdaG_XoAHnaRWizRkVfDkcT3O4g
Message-ID: <AANLkTikE1qnxHcLKax08cVOo_doeXzj5+42-Bt87FGCZ@mail.gmail.com>
Subject: Re: Regression on UP ARM from commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
From: Pekka Enberg <penberg@kernel.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        linux kernel <linux-kernel@vger.kernel.org>, tj@linux.com,
        =?ISO-8859-1?Q?Jonas_=C5berg?= <jonas.aberg@stericsson.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 8:49 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On 9/13/10 4:58 PM, Christoph Lameter wrote:
>>
>> On Sun, 12 Sep 2010, Linus Walleij wrote:
>>
>>> commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
>>> "slub: Remove static kmem_cache_cpu array for boot"
>>> made my ARM 926 UP system hang at boot, if I revert this (have
>>> to back out a lot of SLUB patches for that) it comes back up. (Same if I
>>> switch to SLAB.)
>>>
>>> Any hints on how I can get patch around this in a nice way?
>>
>> This is UP right? Any more details on this one? Does ARM have
>> earlyprintk?
>>
>> Tejun also has some patches that make the percpu allocator work on UP so
>> that we do not need the hack (you must have the hack which is commit
>> c23e5ad729ac43f5e2fbc080f94cf61f07b4d45f as well to make UP work right!).
>>
>> I am not sure if they are already in -next though.
>
> Yes, they should be in linux-next. I haven't pulled the changes to slab.git,
> though. Linus, do things work in linux-next if you revert commit
> 5249d039500f05a5ab379286b1d23ab9b04d3f2c ("Slub: UP bandaid")?

Linus, care to retest linux-next on your configuration? The above
commit has now been replaced with proper UP per-cpu allocator support
by Tejun Heo.

                        Pekka
