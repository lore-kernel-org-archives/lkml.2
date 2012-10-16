Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab2JPQym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:54:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49069 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab2JPQyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:54:40 -0400
Date: Tue, 16 Oct 2012 09:54:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Spang <spang@google.com>, linux-usb@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Michael Spang <spang@chromium.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, greno@verizon.net,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: USB keyboard backlight powering down.
Message-ID: <20121016165436.GA5140@kroah.com>
References: <20121016152023.GA25506@redhat.com>
 <CAC5F_1=tiGUtWOsOQ17vEYqVxuoVuoEH_nmEZ3BoL0dsgXJn3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC5F_1=tiGUtWOsOQ17vEYqVxuoVuoEH_nmEZ3BoL0dsgXJn3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:45:56PM -0400, Michael Spang wrote:
> On Tue, Oct 16, 2012 at 11:20 AM, Dave Jones <davej@redhat.com> wrote:
> > Gerry (CC'd) reported a bug to us that since 3.6.1, his illuminated
> > Logitech USB keyboard doesn't light up until he hits a key, and then
> > it immediately powers back off, defeating the purpose of having an
> > illumated keyboard.
> >
> > Looking over the 3.6.1 changelog, I see this change, which sounds
> > like it might be responsible ?
> >
> > commit ee537508bdc0c00b96ac497f3d82a68f820e6182
> > Author: Michael Spang <spang@chromium.org>
> > Date:   Fri Sep 14 13:05:49 2012 -0400
> >
> >     Increase XHCI suspend timeout to 16ms
> 
> I don't think this is related to your problem, as this patch is in
> suspend/resume code. It just allows the controller more time to halt.

Yeah, that looks odd.

But, (adding linux-usb@vger), I think we enabled some "put the device to
sleep if it is idle" logic for all devices, which is what is looking
like is happening here.  The keyboard is being told to go to sleep in
order to save power.

We are saving more power, but it looks like the user wants to disable
it, which makes sense for this device.

So, do we do this from within the kernel with a blacklist, or rely on
the user knowing how to poke the proper sysfs file to turn the keyboard
back on?

greg k-h

> 
> Thanks,
> Michael
