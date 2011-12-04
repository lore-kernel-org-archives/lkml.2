Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab1LDJhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 04:37:35 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:52694 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289Ab1LDJhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 04:37:31 -0500
Message-ID: <4EDB3F2A.4030801@metafoo.de>
Date: Sun, 04 Dec 2011 10:36:42 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver boilerplate
References: <20111004232403.10364.22050.stgit@ponder>	<20111005065617.GA6824@kroah.com> <CAMuHMdWP+a0jXVBKzJ_J-Rtxdv=CFacDPz91fu=ThwSU_5dOeg@mail.gmail.com>
In-Reply-To: <CAMuHMdWP+a0jXVBKzJ_J-Rtxdv=CFacDPz91fu=ThwSU_5dOeg@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2011 09:39 AM, Geert Uytterhoeven wrote:
> On Wed, Oct 5, 2011 at 08:56, Greg KH <greg@kroah.com> wrote:
>> On Tue, Oct 04, 2011 at 05:26:55PM -0600, Grant Likely wrote:
>>> For simple modules that contain a single platform_driver without any
>>> additional setup code then ends up being a block of duplicated
>>> boilerplate.  This patch adds a new macro, module_platform_driver(),
>>> which replaces the module_init()/module_exit() registrations with
>>> template functions.
>>>
>>> This patch also converts all the relevant spi drivers to use the new
>>> macro.  There are a lot of drivers in the tree that are using this
>>> pattern and could be converted.
>>>
>>> It also fixes up some incorrect section annotations where I found
>>> them.
>>>
>>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>>> ---
>>>
>>> I think this is useful, and I like the diffstat that it produces.
>>> What does everyone else think of this approach?  I can do versions for
>>> i2c_drivers and spi_drivers too.
>>>
>>> This is *not* tested very much.  I'm circulating mostly for review for
>>> now.
>>
>> The idea looks sane to me, I like the diffstat it ends up creating, nice
>> job.
> 
> I guess the macro can be extended (or wrapped around another one) to include
> the bus type, so it applies to all bus types?
> 
> It's a pity some use <bus>_register_driver(), while others use
> <bus>_driver_register(),
> so this needs some refactoring for unification.
>

I've recently posted a patch series which extends the macro to take the bus's
register/unregister function names so it can be used to build macros similar to
module_platform_driver. [1] I used the register/unregister function names
instead of the bus type, exactly because there is no common naming convention
for these. So you still need to define the macro for a new bus type, but it
should be a two-liner.

- Lars

[1] https://lkml.org/lkml/2011/11/16/77
