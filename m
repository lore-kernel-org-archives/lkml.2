Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2LCXl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 18:41:56 -0500
Received: from [207.46.163.24] ([207.46.163.24]:37436 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab2LCXly convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 18:41:54 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI9371I103dK168aJ542I1432Izz1de0h1202h1d1ah1d2ahz8dhz17326ah8275bh8275dhz2dh668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh15d0h162dh1631h1155h)
X-WSS-ID: 0MEHB3O-02-4EC-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Josh Boyer <jwboyer@gmail.com>
CC: Ben Hutchings <ben@decadent.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: RE: [ 67/89] drm/radeon: properly track the crtc not_enabled case
 evergreen_mc_stop()
Thread-Topic: [ 67/89] drm/radeon: properly track the crtc not_enabled case
 evergreen_mc_stop()
Thread-Index: AQHN0WO8PqKu5IyWC0OR0yk1TRaqZpgHlmWA//+b11CAAOrHAP//m6vA
Date: Mon, 3 Dec 2012 23:40:37 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DC1B172@sausexdag04.amd.com>
References: <20121203143146.549859007@decadent.org.uk>
	<20121203143156.904709715@decadent.org.uk>
	<CA+5PVA6P9EDYgt2WSXyX_fNsN26rG3a9j=7vk4b2SncwQ7am+A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC1AF91@sausexdag04.amd.com>
 <CA+5PVA5TcMC7LyinWyK8mQww7RDT87MTetNY0jb2DqXh0b4zCw@mail.gmail.com>
In-Reply-To: <CA+5PVA5TcMC7LyinWyK8mQww7RDT87MTetNY0jb2DqXh0b4zCw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.226.128.3]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Josh Boyer [mailto:jwboyer@gmail.com]
> Sent: Monday, December 03, 2012 6:26 PM
> To: Deucher, Alexander
> Cc: Ben Hutchings; Greg KH; linux-kernel@vger.kernel.org;
> stable@vger.kernel.org; akpm@linux-foundation.org;
> alan@lxorguk.ukuu.org.uk
> Subject: Re: [ 67/89] drm/radeon: properly track the crtc not_enabled case
> evergreen_mc_stop()
> 
> On Mon, Dec 3, 2012 at 10:35 AM, Deucher, Alexander
> <Alexander.Deucher@amd.com> wrote:
> >> -----Original Message-----
> >> From: Josh Boyer [mailto:jwboyer@gmail.com]
> >> Sent: Monday, December 03, 2012 10:25 AM
> >> To: Ben Hutchings; Greg KH
> >> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; akpm@linux-
> >> foundation.org; alan@lxorguk.ukuu.org.uk; Deucher, Alexander
> >> Subject: Re: [ 67/89] drm/radeon: properly track the crtc not_enabled
> case
> >> evergreen_mc_stop()
> >>
> >> On Mon, Dec 3, 2012 at 9:32 AM, Ben Hutchings <ben@decadent.org.uk>
> >> wrote:
> >> > 3.2-stable review patch.  If anyone has any objections, please let me
> know.
> >> >
> >> > ------------------
> >> >
> >> > From: Alex Deucher <alexander.deucher@amd.com>
> >> >
> >> > commit 804cc4a0ad3a896ca295f771a28c6eb36ced7903 upstream.
> >> >
> >> > The save struct is not initialized previously so explicitly
> >> > mark the crtcs as not used when they are not in use.
> >> >
> >> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> >> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >>
> >> Hm.  If this is needed in 3.2, presumably it's needed in 3.6 as well.  I
> >> don't see it queued for 3.6.9, and the Cc: tag is there.
> >>
> >> Greg, Alex, was this just something that was missed, or am I wrong about
> >> it needing to go into 3.6?
> >
> > The original patches should go into 3.6 kernels as well:
> >
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=4
> a15903db02026728d0cf2755c6fabae16b8db6a
> >
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=6
> 2444b7462a2b98bc78d68736c03a7c4e66ba7e2
> >
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=8
> 04cc4a0ad3a896ca295f771a28c6eb36ced7903
> >
> > I've been meaning to follow up on it, but I haven't had the time.  Do I need
> to send explicit patches to stable@vger or can I just ask the above commits
> be cherrypicked to 3.6?
> >
> 
> Normally the CC tag works.  Not entirely sure why it didn't for the one
> patch I asked about.  The other two commits you've highlighted here are
> lacking any sort of stable tag, so you'd have to pipe up here about them.

The patches were not initially a bug fix per se, so I didn't cc stable.  It was only later that I got reports of the patches fixing issues for some people. Normally I add the stable cc if the patch is a bug fix.

> 
> I went ahead and tried the cherry-pick myself on top of 3.6.9, in the
> order you specified above.  The 62444b7462a has a trivial conflict coming
> back.  I've attached an mbox with these three patches.  If you want to
> give them a glance over and OK them, that would be great.

They look good to me.  Thanks!

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> 
> (Apologies for the attachment.  Gmail is going to mess it up otherwise.)
> 
> I have them building locally at the moment on top of 3.6.9 and don't
> expect many issues, but I can't personally test the fixes myself.
> 
> josh

