Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab1HLEqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 00:46:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:62071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab1HLEqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 00:46:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,360,1309762800"; 
   d="scan'208";a="40756476"
Date: Thu, 11 Aug 2011 21:46:05 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Daniel Mack <zonque@gmail.com>
Cc: =?utf-8?B?TWF0xJtq?= Laitl <matej@laitl.cz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Florian Mickler <florian@mickler.org>,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, pedrib@gmail.com,
        William Light <wrl@illest.net>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>
Subject: Re: Allocating buffers for USB transfers (again)
Message-ID: <20110812044605.GA8533@xanatos>
References: <Pine.LNX.4.44L0.1108101025250.1917-100000@iolanthe.rowland.org>
 <3166003.Y8gKYdUrh9@edgy>
 <4E446873.9020508@gmail.com>
 <1451239.ZLFiT5MIDr@edgy>
 <CACTFLANyL95Gy6c2YznV-h0tYdZ7nvRhObsq8dvp9n4_9=D_Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACTFLANyL95Gy6c2YznV-h0tYdZ7nvRhObsq8dvp9n4_9=D_Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 03:28:42AM +0200, Daniel Mack wrote:
> On Fri, Aug 12, 2011 at 1:50 AM, Matěj Laitl <matej@laitl.cz> wrote:
> > On 12. 8. 2011 Daniel Mack wrote:
> >> > This patch actually makes the sound playback _worse_. Now I get strange
> >> > squawks where previously at least first seconds of a song sounded
> >> > normally.
> >> >
> >> > However, I no longer get "zero length buffer submitted" or that "...
> >> > Weird." debug messages, only several megabytes of: (should I post these
> >> > somewhere?)
> >> >
> >> > xhci_hcd 0000:05:00.0: Giveback URB ffff880114cec000, len = 880,
> >> > expected = 1000, status = -115
> >> > xhci_hcd 0000:05:00.0: Giveback URB ffff880114740000, len = 352,
> >> > expected = 1000, status = -115
> >> > xhci_hcd 0000:05:00.0: underrun event on endpoint
> >>
> >> Might be the hardware doesn't like this. As I said, the patch is blindly
> >> written and I couldn't test it. Did you test this on a EHCI port as well?
> >
> > Good point, this patch distorts the playback also on the EHCI port. (the
> > playback seems to be 10 times slower than it should be)
> 
> And it is only this *last* patch that causes it, yes?
> 
> If that is the case, we need empty subframes in the middle of urbs,
> and we need to figure a way how to teach the XHCI driver to cope with
> that, too.

By empty subframes, you mean zero-length frame buffers in the middle of
the URB, correct?  Andiry and Alan had some suggestions for how to fix
that, so I'll try to cook up a patch tomorrow.  Then we'll have to
"unpeel" the debug patches and make sure the system is still usable.

Sarah Sharp
