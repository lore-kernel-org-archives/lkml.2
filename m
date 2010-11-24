Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0KXSDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:03:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37087 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab0KXSDE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:03:04 -0500
MIME-Version: 1.0
In-Reply-To: <4CED48CE.5060300@caviumnetworks.com>
References: <1290607413.12457.44.camel@concordia> <fa44e045-9600-4c46-939a-af246afab4f6@VA3EHSMHS019.ehs.local>
 <4CED48CE.5060300@caviumnetworks.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 24 Nov 2010 11:02:41 -0700
X-Google-Sender-Auth: UrwBy-eprr41B2l28Wms4mgGJew
Message-ID: <AANLkTim+cmxtkw28aeW6ZrspTaiad+w_FHKTys7_NEfR@mail.gmail.com>
Subject: Re: Mega rename of device tree routines from of_*() to dt_*()
To: David Daney <ddaney@caviumnetworks.com>
Cc: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
        michael@ellerman.id.au, LKML <linux-kernel@vger.kernel.org>,
        linux-mips <linux-mips@linux-mips.org>,
        microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:18 AM, David Daney <ddaney@caviumnetworks.com> wrote:
> On 11/24/2010 09:02 AM, Stephen Neuendorffer wrote:
>>
>>
>>> -----Original Message-----
>>> From: linuxppc-dev-bounces+stephen=neuendorffer.name@lists.ozlabs.org
>>> [mailto:linuxppc-dev-
>>> bounces+stephen=neuendorffer.name@lists.ozlabs.org] On Behalf Of Michael
>>> Ellerman
>>> Sent: Wednesday, November 24, 2010 6:04 AM
>>> To: LKML
>>> Cc: linux-mips; microblaze-uclinux@itee.uq.edu.au;
>>> devicetree-discuss@lists.ozlabs.org; linuxppc-dev
>>> list; sparclinux@vger.kernel.org
>>> Subject: RFC: Mega rename of device tree routines from of_*() to dt_*()
>>>
>>> Hi all,
>>>
>>> There were some murmurings on IRC last week about renaming the of_*()
>>> routines. I was procrastinating at the time and said I'd have a look at
>>> it, so here I am.
>>>
>>> The thinking is that on many platforms that use the of_() routines
>>> OpenFirmware is not involved at all, this is true even on many powerpc
>>> platforms. Also for folks who don't know the OpenFirmware connection it
>>> reads as "of", as in "a can of worms".
>>>
>>> Personally I'm a bit ambivalent about it, the OF name is a bit wrong so
>>> it would be nice to get rid of, but it's a lot of churn.
>>>
>>> So I'm hoping people with either say "YES this is a great idea", or "NO
>>> this is stupid".
>>
>> Personally, I think it's a great idea, if only because I stared long and
>> hard
>> at the code once upon a time trying to figure out what is really
>> OF-related
>> and what isn't.  It's somewhat clearer now that drivers/of has been
>> factored
>> out (although, shouldn't it be drivers/dt???)

Yes, the directory name should change, as should the CONFIG_OF* defines.

>>
>> That said, it *is* alot of code churn.  If it's going to be done, I think
>> it should be
>> done in concert with fixing a bunch of the function names which don't
>> really follow any
>> sane naming convention, so that the backporting discontinuity only happens
>> once.
>>
>
> Oh, you mean things like:
>
> of_{,un}register_platform_driver vs. platform_driver_{,un}register
>
> That one is particularly annoying to me.

Ignore that one.  of_{,un}platform_driver is deprecated and users will
all be converted to platform_drivers.

g.
