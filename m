Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793Ab1LNCL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:11:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47676 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab1LNCLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:11:55 -0500
MIME-Version: 1.0
In-Reply-To: <20111214012141.GA18215@kroah.com>
References: <1323309517.979.8.camel@mop> <20111209001145.GB9550@kroah.com>
 <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
 <1323444321.979.39.camel@mop> <20111209223454.GA24987@kroah.com>
 <CAPXgP11fwJ=9E-K4ZpZ-nhf-Ry9=+oX4r7F1mLchxLMmvj_8ZA@mail.gmail.com> <20111214012141.GA18215@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 14 Dec 2011 03:11:34 +0100
Message-ID: <CAPXgP10ZVjy00H3g1YbGJz+e0=mP9hXfdeDT8pOLrDE-e5E5_A@mail.gmail.com>
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 02:21, Greg KH <greg@kroah.com> wrote:
> On Wed, Dec 14, 2011 at 01:50:57AM +0100, Kay Sievers wrote:
>> On Fri, Dec 9, 2011 at 23:34, Greg KH <greg@kroah.com> wrote:
>> > On Fri, Dec 09, 2011 at 04:25:21PM +0100, Kay Sievers wrote:
>> >> Greg, would be nice, if you can take a quick look a the driver core (not
>> >> the sysdev) bits in core.c, bus.c, device.h, ... and its interaction, if
>> >> they look sane to you. I'll then split the driver core stuff out, so we
>> >> can merge that before we port the individual drivers over.
>> >
>> > Yes, it looks sane to me, thanks again for doing this work.
>>
>> Split-up patches are here:
>>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=tree
>>
>> That's the size of it:
>>   60 files changed, 1170 insertions(+), 1421 deletions(-)
>
> Very nice.
>
>> The current state and the list of the remaining non-x86 files is here:
>>   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=README;hb=HEAD
>>
>> We need a plan now. :)
>
> If I take those patches, none of those other ones will break their
> build, right?

The first patch should not break anything, the non-core things shouldn't too.

> Or will the cpu ones?

The cpu patch as it is will break power, s390, sh and tile.
  $ git grep -w -l cpu_sysdev_class
  arch/powerpc/kernel/sysfs.c
  arch/powerpc/platforms/pseries/pseries_energy.c
  arch/s390/kernel/smp.c
  arch/sh/kernel/cpu/sh4/sq.c
  arch/tile/kernel/sysfs.c

If all should be bisectable, we would need to merge these changes into
the cpu patch.

The other two core patches, node and memory, could need arch fixes
too, but a quick grep did not reveal anything.

> I'll look at this tomorrow, gotta go now,

Great.

> I'm burnt out by badly written
> staging patches that must have been created by someone who is bent on
> driving me crazy.

Hehe, you must have expected all that when you came up with the
TAINT_* flag name. :)

Kay
