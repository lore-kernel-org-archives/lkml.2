Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1LESng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:43:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41949 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab1LESnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <20111205181549.GA1612@x4.trippels.de>
References: <20111123160353.GA1673@x4.trippels.de>
	<alpine.DEB.2.00.1111231004490.17317@router.home>
	<20111124085040.GA1677@x4.trippels.de>
	<20111202230412.GB12057@homer.localdomain>
	<20111203092845.GA1520@x4.trippels.de>
	<CAPM=9tyjZc9waC_ZBygW9zh+Zq-Wb1X5Y6yfsCCMPYwpFVWOOg@mail.gmail.com>
	<20111203122900.GA1617@x4.trippels.de>
	<CAH3drwZDOpPuQ_G=LwTiNsR5BNyJTNr+VJU74E6nS5AbKyQH0A@mail.gmail.com>
	<20111204010200.GA1530@x4.trippels.de>
	<20111205171046.GA4342@homer.localdomain>
	<20111205181549.GA1612@x4.trippels.de>
Date: Mon, 5 Dec 2011 13:43:32 -0500
Message-ID: <CAH3drwbZRUV75acco9uWigHLt1brANP1uQ=sAomASdfFv=_AbA@mail.gmail.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Jerome Glisse <j.glisse@gmail.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Dave Airlie <airlied@gmail.com>, Christoph Lameter <cl@linux.com>,
        "Alex, Shi" <alex.shi@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>, tj@kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 1:15 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On 2011.12.05 at 12:10 -0500, Jerome Glisse wrote:
>> On Sun, Dec 04, 2011 at 02:02:00AM +0100, Markus Trippelsdorf wrote:
>> > On 2011.12.03 at 14:31 -0500, Jerome Glisse wrote:
>> > > On Sat, Dec 3, 2011 at 7:29 AM, Markus Trippelsdorf
>> > > <markus@trippelsdorf.de> wrote:
>> > > > On 2011.12.03 at 12:20 +0000, Dave Airlie wrote:
>> > > >> >> > > > > FIX idr_layer_cache: Marking all objects used
>> > > >> >> > > >
>> > > >> >> > > > Yesterday I couldn't reproduce the issue at all. But today I've hit
>> > > >> >> > > > exactly the same spot again. (CCing the drm list)
>> > > >>
>> > > >> If I had to guess it looks like 0 is getting written back to some
>> > > >> random page by the GPU maybe, it could be that the GPU is in some half
>> > > >> setup state at boot or on a reboot does it happen from a cold boot or
>> > > >> just warm boot or kexec?
>> > > >
>> > > > Only happened with kexec thus far. Cold boot seems to be fine.
>> > > >
>> > >
>> > > Can you add radeon.no_wb=1 to your kexec kernel paramater an see if
>> > > you can reproduce.
>> >
>> > No, I cannot reproduce the issue with radeon.no_wb=1. (I write this
>> > after 700 successful kexec iterations...)
>> >
>>
>> Can you try if attached patch fix the issue when you don't pass the
>> radeon.no_wb=1 option ?
>
> Yes the patch finally fixes the issue for me (tested with 120 kexec
> iterations).
> Thanks Jerome!
>
> --
> Markus

Will respin with some minor code changes.

Cheers,
Jerome
