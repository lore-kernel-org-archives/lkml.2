Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab2KXAOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:14:35 -0500
Received: from bsmtp5.bon.at ([195.3.86.187]:44537 "EHLO lbmfmo03.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932296Ab2KXAOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:14:34 -0500
From: Markus Grabner <grabner@icg.tugraz.at>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "line6linux-devel@lists.sourceforge.net" 
	<line6linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>
Subject: Re: [PATCH 00/46] staging: line6: drop MIDI state sysfs attrs
Date: Sat, 24 Nov 2012 01:13:36 +0100
Message-ID: <6166224.2emsEYaK8t@medialab>
User-Agent: KMail/4.9.1 (Linux/3.4.11-2.16-desktop; KDE/4.9.2; x86_64; ; )
In-Reply-To: <CAJSP0QUai4O12U7fbrARAZLOig5=10e1WYg7i+OZTDETuDRWoQ@mail.gmail.com>
References: <1353613765-18690-1-git-send-email-stefanha@gmail.com> <20121122195840.GA26543@kroah.com> <CAJSP0QUai4O12U7fbrARAZLOig5=10e1WYg7i+OZTDETuDRWoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 22. November 2012, 21:08:55 schrieb Stefan Hajnoczi:
> On Thu, Nov 22, 2012 at 8:58 PM, Greg Kroah-Hartman
> 
> <gregkh@linuxfoundation.org> wrote:
> > On Thu, Nov 22, 2012 at 08:48:39PM +0100, Stefan Hajnoczi wrote:
> >> Markus and I have discussed the MIDI processing that currently happens in
> >> the line6 driver.  This stuff really belongs in userspace where a
> >> library or utility can use ALSA MIDI APIs to control the device.  Moving
> >> MIDI processing to userspace has several benefits:
> >> 
> >> 1. The driver only handles PCM and MIDI I/O.  This means less kernel
> >> code.
> >> 
> >> 2. A large number of sysfs attributes can be removed.  These attributes
> >> exposed>> 
> >>    MIDI state and driver code was necessary to sync and manage this
> >>    state.
> >> 
> >> 3. It's easier for userspace to control the device, try out new MIDI
> >> commands,>> 
> >>    etc when the driver acts as a dumb transport.
> >> 
> >> This patch series removes the sysfs attributes and then removes the state
> >> behind those attributes.  I have tried to make small incremental changes
> >> that can be reviewed easily.
> > 
> > Very nice, I'll queue these up on Monday, very good work, thanks so much
> > for doing this.
> 
> Thanks!  I hope Markus has a chance to review and/or test these
> changes first - he knows generally what I'm up too but should have the
> final word on details.
I just applied all patches and did a quick check with the PODxt Live. The 
following features are still working:
*) the user space code which receives and interprets (at least some) MIDI 
messages from the device
*) ALSA playback
*) ALSA volume and monitor controls

I will have a look at the Variax and TonePort later.

	Kind regards,
		Markus

