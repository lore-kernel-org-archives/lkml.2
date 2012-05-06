Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab2EFRiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:38:22 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:42589 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab2EFRiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:38:20 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnlyAM+2pk9V5qg+PGdsb2JhbABEsUgEgR4ZAQEBATc0ggwBAQQBOhwREgULCANGFCUKGogcCQe5WBOLK4R+YwSVfYEShHSDVYlT
X-IronPort-AV: E=Sophos;i="4.75,539,1330902000"; 
   d="scan'208";a="327701388"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 6 May 2012 19:43:16 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Chase Douglas <chasedouglas@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] input: Introduce MT_CENTER_X and MT_CENTER_Y
Message-ID: <20120506174316.GA8465@polaris.bitmath.org>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com>
 <1336136030-18503-5-git-send-email-benjamin.tissoires@gmail.com>
 <20120504134831.GA8263@polaris.bitmath.org>
 <CAN+gG=EfOjm5AX+g22ksFTZhw-rdjT5vWmh0mu6RQZ8oXPCRqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=EfOjm5AX+g22ksFTZhw-rdjT5vWmh0mu6RQZ8oXPCRqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> > I would like a bit of elaboration here, since I am not convinced the
> > mapping should be directly translated to the MT protocol.
> >
> > Clearly, the basic idea to be able to model an assymmetric tool is
> > good. Without an angle description, however, there seems to be a
> > mismatch in the degrees of freedom. In win8, one can place the hot
> > spot in a corner of the rectangle, but one cannot make the rectangle
> > into an ellipse in that direction.
> 
> That's not the interpretation I made of the spec.
> http://msdn.microsoft.com/library/windows/hardware/br259100

Yep, we are referring to the same file.

> Win8 is a total respin of the multitouch protocol (though backward
> compatible). It asks for a lot more reliability and performances for
> the devices.
> From what I understood, the T point (the touch) can be an arbitrary
> point within the ellipse. Furthermore, the ellipse can be oriented in
> an arbitrary rotation (like linux) because they introduced the hid
> field Azimuth (0x3f) that is the "Counter-clockwise rotation of the
> cursor around the Z axis".

The document is a bit unclear on what object azimuth is referring to,
and whether it correlates with the C-T vector, but essentially, there
is a lot more details, I agree.

> To sum up, there are two kind of information:
> - The touch point (where the user wants to touch)
> - The elliptic shape of the touch (width, height, center, azimuth, pressure)

Width and height still refer to the bounding box, that much is clear
from the document. The shape modelled by azimuth is not quite that
clear.

> I think these two information are interesting as most of the time, the
> center of the ellipse is _not_ the point where the user wants to
> touch. The best thing to test that is to see how many time you miss
> the pixel you want to touch in the current implementation.

No argument here; separating the touch and shape points is a great
improvement. It also gives directional information in a simpler manner
than via the shape angle.

> I also wanted to publish these 2 last patches to raise the discussion,
> and to show that the fix of the randomness in the splitting of the
> touches within the reports was compatible with new kinds of devices.
> 
> We should focus for now (3.5) on the first 3 patches, and let aside
> the 2 last for the next version, when everyone agrees.

Yes, it may well be that the userland discussion carries over into
3.6, and we can certainly treat the hid enablement separately.

More to come on the shape modelling in the other thread.

Thanks,
Henrik
