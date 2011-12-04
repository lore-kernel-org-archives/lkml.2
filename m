Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1LDK1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 05:27:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46091 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1LDK1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 05:27:22 -0500
MIME-Version: 1.0
In-Reply-To: <4EDB3F2A.4030801@metafoo.de>
References: <20111004232403.10364.22050.stgit@ponder>
	<20111005065617.GA6824@kroah.com>
	<CAMuHMdWP+a0jXVBKzJ_J-Rtxdv=CFacDPz91fu=ThwSU_5dOeg@mail.gmail.com>
	<4EDB3F2A.4030801@metafoo.de>
Date: Sun, 4 Dec 2011 11:27:20 +0100
X-Google-Sender-Auth: UT37CqczXRxYwYFBXYFKoxWTd1g
Message-ID: <CAMuHMdVNgLQcXfW3xZ0Q2_Dh2JSjKCRJdJxpaLmUUDppBfqhPQ@mail.gmail.com>
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver boilerplate
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

On Sun, Dec 4, 2011 at 10:36, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 12/04/2011 09:39 AM, Geert Uytterhoeven wrote:
>> On Wed, Oct 5, 2011 at 08:56, Greg KH <greg@kroah.com> wrote:
>>> On Tue, Oct 04, 2011 at 05:26:55PM -0600, Grant Likely wrote:
>>>> For simple modules that contain a single platform_driver without any
>>>> additional setup code then ends up being a block of duplicated
>>>> boilerplate.  This patch adds a new macro, module_platform_driver(),
>>>> which replaces the module_init()/module_exit() registrations with
>>>> template functions.
>>>>
>>>> This patch also converts all the relevant spi drivers to use the new
>>>> macro.  There are a lot of drivers in the tree that are using this
>>>> pattern and could be converted.
>>>>
>>>> It also fixes up some incorrect section annotations where I found
>>>> them.
>>>>
>>>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>>> ---
>>>>
>>>> I think this is useful, and I like the diffstat that it produces.
>>>> What does everyone else think of this approach?  I can do versions for
>>>> i2c_drivers and spi_drivers too.
>>>>
>>>> This is *not* tested very much.  I'm circulating mostly for review for
>>>> now.
>>>
>>> The idea looks sane to me, I like the diffstat it ends up creating, nice
>>> job.
>>
>> I guess the macro can be extended (or wrapped around another one) to include
>> the bus type, so it applies to all bus types?
>>
>> It's a pity some use <bus>_register_driver(), while others use
>> <bus>_driver_register(),
>> so this needs some refactoring for unification.
>>
>
> I've recently posted a patch series which extends the macro to take the bus's
> register/unregister function names so it can be used to build macros similar to
> module_platform_driver. [1] I used the register/unregister function names
> instead of the bus type, exactly because there is no common naming convention
> for these. So you still need to define the macro for a new bus type, but it
> should be a two-liner.
>
> - Lars
>
> [1] https://lkml.org/lkml/2011/11/16/77

Great! Thanks, I missed that one.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
