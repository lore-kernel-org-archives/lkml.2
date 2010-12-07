Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0LGUk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 15:40:58 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60171 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0LGUk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 15:40:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=melD1p2iJI9CqczJB8KV3KLdf7ARLTEU4mE6trox9wiZPACd0LLMNUwr8eKw3KOQZv
         7Gmx0GQzxfHnTt6Lce7NQ4O1EMemXdoPtx4dQgx4o6wEhlS5dIfKmfAkMLjRi/A1W0bA
         VENO2LCNHgX98BzrJ0kLJ9ZF1apyqBoxj1q+0=
MIME-Version: 1.0
In-Reply-To: <AANLkTik2SWrmVJ1o98-e2CwJP9SAo6oMmnuLc4K+rT1R@mail.gmail.com>
References: <AANLkTikVM=zakYF7uhX1mYHy9QUVL6dmEPNsmV7=oyuh@mail.gmail.com>
	<AANLkTi=iH6QOAph0iW6MR2khD5KCe8mRLPe8Y3QnTTTW@mail.gmail.com>
	<AANLkTik2SWrmVJ1o98-e2CwJP9SAo6oMmnuLc4K+rT1R@mail.gmail.com>
Date: Tue, 7 Dec 2010 15:40:55 -0500
Message-ID: <AANLkTikdNXdDoixEzGbirH+U_v62vDeEMGaRRpvTsJpu@mail.gmail.com>
Subject: Re: visibility changes (was: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 7, 2010 at 3:31 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Dec 7, 2010 at 20:51, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> On Tue, Dec 7, 2010 at 2:07 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>>> On Sat, Dec 4, 2010 at 14:57, Michal Marek <mmarek@suse.cz> wrote:
>>>> please pull these kbuild/kconfig fixes for the next -rc. The largest
>>>> part are fixes for the annoying kconfig warnings, contributed by Arnaud
>>>> Lacombe and Mauro Carvalho Chehab. The solution adds a new 'visible if'
>>>> keyword to the Kconfig language, so it's not exactly something that one
>>>> would expect in the rc phase, but the kconfig change is not huge (the
>>>> large diff is due to generated files) and it is deployed only in those
>>>> five Kconfig files that had the warnings and were hard to fix by other
>>>> means.  The second part is a forgotten patch by Hendrik Brueckner to
>>>> usr/initramfs, that fixes build for Blackfin and h8300.
>>>
>>>> Arnaud Lacombe (5):
>>>>      kconfig: add an option to determine a menu's visibility
>>>
>>> Hmm, this changeset also went in through the v4l tree?
>>>
>> Mauro merely imported the set in his tree to give them visibility and
>> testing, but they went in trough the kbuild tree after being in -next
>> for a week.
>
> Hmm, git show 86e187ff9bce9fbed7bfed92ae34f491cf1af50f doesn't
> show a SoB from Michal...
>
Why would you expect it to ? Most of the commit in Linus' tree are not
personally SoB by him.

>>> BTW, I got confused:
>>>  - make allmodconfig causes e.g.:
>>>        CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>>>        CONFIG_VIDEO_TVAUDIO=m
>>>    => good
>>>  - make oldconfig for my config with almost everything selected,
>>> except for stuff I know that breaks:
>>>        CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
>>>        # CONFIG_VIDEO_TVAUDIO is not set
>>>    and no way to manually set CONFIG_VIDEO_TVAUDIO=y?
>>>    => bad!
>> that's difficult to judge without your old configuration.
>> VIDEO_TVAUDIO is only selected by VIDEO_BT848 which you don't give
>> information about.
>
> I don't have PCI, so I cannot enable VIDEO_BT848.
>
so why do you expect VIDEO_TVAUDIO to be enabled ?

 - Arnaud
