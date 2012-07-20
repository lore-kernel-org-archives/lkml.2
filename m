Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2GTNCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 09:02:43 -0400
Received: from csmtp2.one.com ([91.198.169.22]:48111 "EHLO csmtp2.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab2GTNCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 09:02:42 -0400
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Fri, 20 Jul 2012 15:03:50 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Chung-Yih Wang =?utf-8?B?KOeOi+W0h+aHvyk=?= <cywang@google.com>,
        Chase Douglas <chase.douglas@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: synaptics - use firmware data for Cr-48
Message-ID: <20120720130350.GA1508@polaris.bitmath.org>
References: <1342606923-9997-1-git-send-email-cywang@chromium.org>
 <5006D86C.7030208@canonical.com>
 <CAM2ehZbftDja6CBGjhL3Jp+30DtYJj+8_4e=_wWcj3pCDGD7AA@mail.gmail.com>
 <500832D7.4040805@canonical.com>
 <CAGS+omA-PwoM=U3xP_Gtadaow9SGt555NPWor_-HuvVE8-R3MQ@mail.gmail.com>
 <50084529.2030001@canonical.com>
 <20120719184419.GA3626@polaris.bitmath.org>
 <CAM2ehZaLeJsxCOkqLv9jSko9y3Awix1jjobfTo5WQj8rcrYquA@mail.gmail.com>
 <20120720072510.GA986@polaris.bitmath.org>
 <CAGS+omBmkdrpLds4xE==BNp1yctOmA1xj-p2s4S8Bvh7Q=ixxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGS+omBmkdrpLds4xE==BNp1yctOmA1xj-p2s4S8Bvh7Q=ixxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Propagating information about various sensor defects to userspace
> > sounds horrid to me. The sooner we can forget about these devices, the
> > better.
> 
> Not providing the userspace driver with enough information to give
> users the best experience possible sounds horrid to me.

The question was whether we should add those to the long-lived input
interface or not, sorry if that sounded like a rant.

> It turns out
> that using a bounding box with fixed "[(min_x, min_y), (max_x,
> max_y)]", and no per-finger pressure information, instead of the
> coordinates and pressures provided by the firmware, is throwing away
> useful data that could be used by the userspace driver.

So far, we have provided the baseline of reliable data from similar
devices.

> What we would like is a way to tell userspace what the firmware
> originally intended, but with a caveat that the firmware can't be 100%
> trusted.  And, since this is for a relatively small class of hardware,
> to do it in a way that doesn't consume precious resources, like
> additional input properties.

Input properties are not a precious resource, there is no limit on the
bitmask values or anything like that, but there is no rush to add new
ones.

> >> > > * Leave the device as SEMI_MT, but provide the real locations, and
> >> > > allow userspace to determine the device vendor/model/etc. If
> >> > > userspace knows that a specific device behaves in a specific way, it
> >> > > can do its own quirking handling. Given the specificity of this
> >> > > behavior to only some devices of one brand, this would be my
> >> > > suggested resolution to the issue.
> >> >
> 
> This is essentially what this patch does.

I am interpreting Chase's suggestion as simply reporting the raw
values instead of min/max.

> It sets the SEMI_MT flag to
> indicate that the kernel data cannot be totally trusted, and then
> provides real MT-B (including per-finger pressures), instead of a
> fixed bounding box.  It leaves it to userspace to treat the two slots
> worth of coordinates as a bounding box or as actual fingers using its
> own heuristics.  By limiting to only one hardware type (using DMI),
> any breakage caused by this alternative use of the SEMI_MT flag is
> limited.

So it seems there is no need to add logic to the driver, only change
one line from min/max to raw data for this particular hardware. That
would solve your problem, yes?

> Hopefully it is clear what we are trying to accomplish.  I don't see
> how we can make a bounding box, even an improved bounding box, work.
> Perhaps Henrik has a really good idea, but I haven't been able to
> figure out what he is suggesting.

I understand you are not interested in looking into this, and your
main objective is quite clear.

Thanks,
Henrik
