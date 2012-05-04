Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab2EDFCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:02:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44576 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2EDFCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:02:38 -0400
Message-ID: <1336108085.1803.10.camel@nisroch>
Subject: Re: Linux 3.4-rc4
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Jean Delvare <jdelvare@suse.de>
Cc: Bowler <nbowler@elliptictech.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Nick@freedesktop.org,
        Martin Peres <martin.peres@labri.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 04 May 2012 15:08:05 +1000
In-Reply-To: <1335958306.1898.7.camel@nisroch>
References: <20120422164023.GA32342@elliptictech.com>
	 <CAGZ4FETGyatywWqx3vLo-=jSJsrSat2+r35Njg5NNJ4NnyUy=w@mail.gmail.com>
	 <CAKPcRGpxb6b-z3t8Lv6YU9+ttgeXTRtGyvCFb=RSDQOJMTqEjQ@mail.gmail.com>
	 <201205020954.13273.jdelvare@suse.de> <1335958306.1898.7.camel@nisroch>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-1.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-02 at 21:31 +1000, Ben Skeggs wrote:
> On Wed, 2012-05-02 at 09:54 +0200, Jean Delvare wrote:
> > Hi Luca, Maarten,
> > 
> > On Monday 30 April 2012 01:01:30 pm Luca Tettamanti wrote:
> > > On Mon, Apr 30, 2012 at 11:07 AM, Maarten Maathuis <madman2003@gmail.com> wrote:
> > > > On Mon, Apr 30, 2012 at 12:37 AM, Dmitry Torokhov
> > > >
> > > > <dmitry.torokhov@gmail.com> wrote:
> > > >> On Sat, Apr 28, 2012 at 11:33:50AM -0400, Nick Bowler wrote:
> > > >>> On 2012-04-28 02:19 -0400, Alex Deucher wrote:
> > > >>> > On Fri, Apr 27, 2012 at 8:39 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> > > >>> > > Unfortunately, that's not the end of my VGA-related
> > > >>> > > regressions. :(
> > > >>> > >
> > > >>> > > While tracking down the black screen issue, I've been having
> > > >>> > > the monitor directly connected to the video card the whole
> > > >>> > > time, but now when I'm connected through my KVM switch (an
> > > >>> > > IOGear GCS1804), it appears that something's going wrong with
> > > >>> > > reading the EDID, because the available modes are all screwed
> > > >>> > > up (both console and X decide they want to drive the display
> > > >>> > > at 1024x768).  Here's the output of xrandr on 3.2.15:
> > > >>> > >
> > > >>> > >  % xrandr
> > > >>> > >  Screen 1: minimum 320 x 200, current 1600 x 1200, maximum
> > > >>> > > 4096 x 4096 VGA-1 connected 1600x1200+0+0 (normal left
> > > >>> > > inverted right x axis y axis) 352mm x 264mm
> > > >>> > >     1600x1200      75.0*+   70.0     65.0     60.0
> > > >>> > >     1280x1024      85.0 +   75.0     60.0
> > > >>> > >     1920x1440      60.0
> > > >>> > >     1856x1392      60.0
> > > >>> > >     1792x1344      60.0
> > > >>> > >     1920x1200      74.9     59.9
> > > >>> > >     1680x1050      84.9     74.9     60.0
> > > >>> > >     1400x1050      85.0     74.9     60.0
> > > >>> > >     1440x900       84.8     75.0     59.9
> > > >>> > >     1280x960       85.0     60.0
> > > >>> > >     1360x768       60.0
> > > >>> > >     1280x800       84.9     74.9     59.8
> > > >>> > >     1152x864       75.0
> > > >>> > >     1280x768       84.8     74.9     59.9
> > > >>> > >     1024x768       85.0     75.1     75.0     70.1     60.0     43.5     43.5
> > > >>> > >     832x624        74.6
> > > >>> > >     800x600        85.1     72.2     75.0     60.3     56.2
> > > >>> > >     848x480        60.0
> > > >>> > >     640x480        85.0     75.0     72.8     72.8     66.7     60.0     59.9
> > > >>> > >     720x400        85.0     87.8     70.1
> > > >>> > >     640x400        85.1
> > > >>> > >     640x350        85.1
> > > >>> > >     320x200       165.1
> > > >>> > >
> > > >>> > > And on 3.4-rc4+ (with your patch cherry-picked):
> > > >>> > >
> > > >>> > >  % xrandr
> > > >>> > >  Screen 1: minimum 320 x 200, current 1024 x 768, maximum
> > > >>> > > 4096 x 4096 VGA-1 connected 1024x768+0+0 (normal left
> > > >>> > > inverted right x axis y axis) 0mm x 0mm
> > > >>> > >     1024x768       60.0*
> > > >>> > >     800x600        60.3     56.2
> > > >>> > >     848x480        60.0
> > > >>> > >     640x480        59.9
> > > >>> > >     320x200       165.1
> > > >>> > >
> > > >>> > > Running xrandr on 3.4-rc4+ also causes the screen to go black
> > > >>> > > for a second when it does not on 3.2.15.  It also causes
> > > >>> > > several messages of the form
> > > >>> > >
> > > >>> > >  [drm] nouveau 0000:01:00.0: Load detected on output B
> > > >>> > >
> > > >>> > > to be logged.  Also, looking at
> > > >>> > > /sys/class/drm/card0-VGA-1/edid I see that it is empty on
> > > >>> > > 3.4-rc4+ and it is correct on 3.2.15.  Things seem to work OK
> > > >>> > > when the KVM is not involved.
> > > >>> >
> > > >>> > Were you ever able to fetch a EDID with the KVM involved?  KVMs
> > > >>> > are notorious for not connecting the ddc pins.
> > > >>>
> > > >>> Yes, it works on 3.2.15 as described above.
> > > >>
> > > >> I have the same (or similar) KVM (not in the office at the moment)
> > > >> and I can confirm that with newer kernels EDID fecthing in flaky.
> > > >> It's 50/50 if EDED retrieval succeeds or if it fails with:
> > > >>
> > > >> Apr 26 13:06:57 dtor-d630 kernel: [13464.936336]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 26 13:06:57 dtor-d630 kernel: [13464.955317]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 26 13:06:57 dtor-d630 kernel: [13464.973879]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 27 09:13:03 dtor-d630 kernel: [44602.087659]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 27 09:13:03 dtor-d630 kernel: [44602.107147]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 27 09:13:03 dtor-d630 kernel: [44602.126908]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 27 09:13:03 dtor-d630 kernel: [44602.146277]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 27 09:13:03 dtor-d630 kernel: [44602.297659]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208 Apr 27 09:13:03 dtor-d630 kernel: [44602.317063]
> > > >> [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid,
> > > >> remainder is 208
> > > >>
> > > >> Earlier kernels were able to retrieve EDEDs reliably.
> > > >>
> > > >> This is with:
> > > >>
> > > >> [    1.678392] [drm] nouveau 0000:01:00.0: Detected an NV50
> > > >> generation card (0x086b00a2)
> > > >
> > > > Just a crazy thought, but didn't we change some timings related to
> > > > EDID retrieval? To make it faster.
> > > 
> > > Hum, this commit:
> > > 
> > > commit 1849ecb22fb3b5d57b65e7369a3957adf9f26f39
> > > Author: Jean Delvare <jdelvare@suse.de>
> > > Date:   Sat Jan 28 11:07:09 2012 +0100
> > > 
> > >     drm/kms: Make i2c buses faster
> > > 
> > > doubled the data rate but only for radeon and intel drivers. nouveau
> > > doesn't use the standard i2c-algo-bit helpers (BTW: the
> > >  cond_resched() has been removed), and AFAICS it's using 1us delay;
> > >  the other drivers are using 10us, 1us seems a bit too low...
> > 
> > As I read the code, it is actually using a 6 us delay. This is fast
> > but reasonable, especially when the code handles clock stretching 
> > 
> > Ben Skeggs (Cc'd) rewrote the I2C handling code in the nouveau
> > driver completely in kernel 3.3:
> > 
> > commit f553b79c03f0dbd52f6f03abe8233a2bef8cbd0d
> > Author: Ben Skeggs <bskeggs@redhat.com>
> > Date:   Wed Dec 21 18:09:12 2011 +1000
> > 
> >     drm/nouveau/i2c: handle bit-banging ourselves
> > 
> >     i2c-algo-bit doesn't actually work very well on one card I have access to
> >     (NVS 300), random single-bit errors occur most of the time - what we're
> >     doing now is closer to what xf86i2c.c does.
> > 
> >     The original plan was to figure out why i2c-algo-bit fails on the NVS 300,
> >     and fix it.  However, while investigating I discovered i2c-algo-bit calls
> >     cond_resched(), which makes it a bad idea for us to be using as we execute
> >     VBIOS scripts from a tasklet, and there may very well be i2c transfers as
> >     a result.
> > 
> >     So, since I already wrote this code in userspace to track down the NVS 300
> >     bug, and it's not really much code - lets use it.
> > 
> >     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
> > 
> > So if the regression happened between 3.2.15 and 3.4-rc4, that would be
> > a good candidate.
> > 
> > BTW, Ben, there were two interesting fixes to i2c-algo-bit meanwhile,
> > you may want to try using it again.
> Hey Jean,
> 
> Thanks!  I did notice this, and your email, a while back.  I just
> haven't yet had the time to see how the NVS300 goes now.  I do
> definitely plan on taking a peek however.
I had the NVS300 in today for some other work so I took the chance to
see how it went now.  The good news is, i2c-algo-bit works with it now
\o/

I've got a patch ready removing our custom implementation, and it'll be
in nouveau git later today.

Thanks a heap for the heads up, and for fixing my issues with
i2c-algo-bit!

Ben.

> 
> Ben.
> 
> > 
> > Maarten, another commit you may want to try reverting is
> > 9292f37e1f5c79400254dca46f83313488093825 . If none of the above works,
> > it would be great if you could test your KVM with another graphics
> > adapter, so that we know if we are looking for a nouveau-specific bug
> > or rather an issue in the common i2c or edid code. Otherwise a plain
> > bisection is probably the way to go.
> > 
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


