Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab1HVVFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:05:25 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65099 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab1HVVFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:05:22 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>, rydberg@euromail.se
Subject: Re: [PATCH 4/9 v5] Input: synaptics - add image sensor support
Date: Mon, 22 Aug 2011 14:05:15 -0700
User-Agent: KMail/1.13.7 (Linux/2.6.40.3-0.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Daniel Kurtz <djkurtz@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, chris@cnpbagwell.com
References: <1314011163-19098-1-git-send-email-djkurtz@chromium.org> <1314011163-19098-5-git-send-email-djkurtz@chromium.org> <4E52C252.9060904@canonical.com>
In-Reply-To: <4E52C252.9060904@canonical.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108221405.15767.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 22, 2011 01:55:46 PM Chase Douglas wrote:
> On 08/22/2011 04:05 AM, Daniel Kurtz wrote:
> > Synaptics makes (at least) two kinds of touchpad sensors:
> >  * Older pads use a profile sensor that could only infer the location
> >  
> >    of individual fingers based on the projection of their profiles
> >    onto row and column sensors.
> >  
> >  * Newer pads use an image sensor that can track true finger position
> >  
> >    using a two-dimensional sensor grid.
> > 
> > Both sensor types support an "Advanced Gesture Mode":
> >  When multiple fingers are detected, the touchpad sends alternating
> >  "Advanced Gesture Mode" (AGM) and "Simple Gesture Mode" (SGM)
> >  packets.
> >  The AGM packets have w=2, and contain reduced resolution finger data
> >  The SGM packets have w={0,1} and contain full resolution finger data
> > 
> > Profile sensors try to report the "upper" (larger y value) finger in
> > the SGM packet, and the lower (smaller y value) in the AGM packet.
> > However, due to the nature of the profile sensor, they easily get
> > confused when fingers cross, and can start reporting the x-coordinate
> > of one with the y-coordinate of the other.  Thus, for profile
> > sensors, "semi-mt" was created, which reports a "bounding box"
> > created by pairing min and max coordinates of the two pairs of
> > reported fingers.
> > 
> > Image sensors can report the actual coordinates of two of the fingers
> > present.  This patch detects if the touchpad is an image sensor and
> > reports finger data using the MT-B protocol.
> > 
> > NOTE: This patch only adds partial support for 2-finger gestures.
> > 
> >       The proper interpretation of the slot contents when more than
> >       two fingers are present is left to later patches.  Also,
> >       handling of 'number of fingers' transitions is incomplete.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> 
> It's fine with me. It adds a bit of asymmetry in packet processing
> between mt and non-mt trackpads. This could be reworked by splitting
> synaptics_process_packet() up into an mt case function (which is what
> synaptics_image_sensor_process() is), and a non-mt case function. I
> think that would be nice, but not a big deal so:
> 
> Acked-by: Chase Douglas <chase.douglas@canonical.com>

Right, I think it can be done later; I am quite happy with the code at
the moment...

Henrik, you commented a few times on the earlier patches, are you happy
with this version?

Thanks.

-- 
Dmitry
