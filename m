Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2D3JIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:08:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63761 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2D3JH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120429223744.GA19382@core.coreip.homeip.net>
References: <20120422164023.GA32342@elliptictech.com>
	<20120423000554.GA893@elliptictech.com>
	<20120423024558.GD13840@phenom.dumpdata.com>
	<20120424010345.GA30674@elliptictech.com>
	<20120425013537.GA11959@elliptictech.com>
	<1335322574.1821.8.camel@nisroch>
	<1335504021.5311.0.camel@nisroch>
	<20120428003928.GA16805@elliptictech.com>
	<CADnq5_N8Cf4ONL5TNA-Wmif7cty070TRrTOnUpqdiGhWbVbj=w@mail.gmail.com>
	<20120428153350.GA19561@elliptictech.com>
	<20120429223744.GA19382@core.coreip.homeip.net>
Date: Mon, 30 Apr 2012 11:07:57 +0200
Message-ID: <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
Subject: Re: Linux 3.4-rc4
From: Maarten Maathuis <madman2003@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Martin Peres <martin.peres@labri.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 12:37 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Sat, Apr 28, 2012 at 11:33:50AM -0400, Nick Bowler wrote:
>> On 2012-04-28 02:19 -0400, Alex Deucher wrote:
>> > On Fri, Apr 27, 2012 at 8:39 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
>> > > Hi Ben,
>> > >
>> > > On 2012-04-27 15:20 +1000, Ben Skeggs wrote:
>> > >> Does this patch help you at all?
>> > >>
>> > >> http://cgit.freedesktop.org/nouveau/linux-2.6/commit/?id=a3a285f17867f0018de798b5ee85731ec1268305
>> > >
>> > > Yes.  I cherry-picked this patch on top of Linus' master (3.4-rc4+) and
>> > > this appears to solve the "black screen on VGA" problem described in the
>> > > original report.  Thanks!
>> > >
>> > > Unfortunately, that's not the end of my VGA-related regressions. :(
>> > >
>> > > While tracking down the black screen issue, I've been having the monitor
>> > > directly connected to the video card the whole time, but now when I'm
>> > > connected through my KVM switch (an IOGear GCS1804), it appears that
>> > > something's going wrong with reading the EDID, because the available
>> > > modes are all screwed up (both console and X decide they want to drive
>> > > the display at 1024x768).  Here's the output of xrandr on 3.2.15:
>> > >
>> > >  % xrandr
>> > >  Screen 1: minimum 320 x 200, current 1600 x 1200, maximum 4096 x 4096
>> > >  VGA-1 connected 1600x1200+0+0 (normal left inverted right x axis y axis) 352mm x 264mm
>> > >     1600x1200      75.0*+   70.0     65.0     60.0
>> > >     1280x1024      85.0 +   75.0     60.0
>> > >     1920x1440      60.0
>> > >     1856x1392      60.0
>> > >     1792x1344      60.0
>> > >     1920x1200      74.9     59.9
>> > >     1680x1050      84.9     74.9     60.0
>> > >     1400x1050      85.0     74.9     60.0
>> > >     1440x900       84.8     75.0     59.9
>> > >     1280x960       85.0     60.0
>> > >     1360x768       60.0
>> > >     1280x800       84.9     74.9     59.8
>> > >     1152x864       75.0
>> > >     1280x768       84.8     74.9     59.9
>> > >     1024x768       85.0     75.1     75.0     70.1     60.0     43.5     43.5
>> > >     832x624        74.6
>> > >     800x600        85.1     72.2     75.0     60.3     56.2
>> > >     848x480        60.0
>> > >     640x480        85.0     75.0     72.8     72.8     66.7     60.0     59.9
>> > >     720x400        85.0     87.8     70.1
>> > >     640x400        85.1
>> > >     640x350        85.1
>> > >     320x200       165.1
>> > >
>> > > And on 3.4-rc4+ (with your patch cherry-picked):
>> > >
>> > >  % xrandr
>> > >  Screen 1: minimum 320 x 200, current 1024 x 768, maximum 4096 x 4096
>> > >  VGA-1 connected 1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
>> > >     1024x768       60.0*
>> > >     800x600        60.3     56.2
>> > >     848x480        60.0
>> > >     640x480        59.9
>> > >     320x200       165.1
>> > >
>> > > Running xrandr on 3.4-rc4+ also causes the screen to go black for a
>> > > second when it does not on 3.2.15.  It also causes several messages of
>> > > the form
>> > >
>> > >  [drm] nouveau 0000:01:00.0: Load detected on output B
>> > >
>> > > to be logged.  Also, looking at /sys/class/drm/card0-VGA-1/edid I see
>> > > that it is empty on 3.4-rc4+ and it is correct on 3.2.15.  Things seem
>> > > to work OK when the KVM is not involved.
>> >
>> > Were you ever able to fetch a EDID with the KVM involved?  KVMs are
>> > notorious for not connecting the ddc pins.
>>
>> Yes, it works on 3.2.15 as described above.
>
> I have the same (or similar) KVM (not in the office at the moment) and I
> can confirm that with newer kernels EDID fecthing in flaky. It's 50/50
> if EDED retrieval succeeds or if it fails with:
>
> Apr 26 13:06:57 dtor-d630 kernel: [13464.936336] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 26 13:06:57 dtor-d630 kernel: [13464.955317] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 26 13:06:57 dtor-d630 kernel: [13464.973879] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 27 09:13:03 dtor-d630 kernel: [44602.087659] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 27 09:13:03 dtor-d630 kernel: [44602.107147] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 27 09:13:03 dtor-d630 kernel: [44602.126908] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 27 09:13:03 dtor-d630 kernel: [44602.146277] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 27 09:13:03 dtor-d630 kernel: [44602.297659] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
> Apr 27 09:13:03 dtor-d630 kernel: [44602.317063] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 208
>
> Earlier kernels were able to retrieve EDEDs reliably.
>
> This is with:
>
> [    1.678392] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card (0x086b00a2)
>
> Thanks.
>
> --
> Dmitry
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


Just a crazy thought, but didn't we change some timings related to
EDID retrieval? To make it faster.

-- 
Far away from the primal instinct, the song seems to fade away, the
river get wider between your thoughts and the things we do and say.
