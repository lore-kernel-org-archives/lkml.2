Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2GAXZo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 19:25:44 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36959 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab2GAXZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 19:25:43 -0400
Date: Sun, 1 Jul 2012 18:25:42 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Message-ID: <20120701232542.GA11680@gherkin.frus.com>
References: <20120628131651.GA14492@gherkin.frus.com> <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com> <20120629033600.GA3591@gherkin.frus.com> <20120630033519.GA4792@kroah.com> <20120701201411.GB8603@gherkin.frus.com> <20120701204118.GA1018@polaris.bitmath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701204118.GA1018@polaris.bitmath.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 10:41:18PM +0200, Henrik Rydberg wrote:
> > Kernel built from the standard kernel.org tree.  All
> > drivers needed at boot time are built-in, except now there's probably
> > something missing on the USB side of things.  No initrd.
> 
> Are modules turned off as well?

No.  The only drivers that are built-in are the ones I need at boot time
and/or continuously thereafter.  Everything else is modular.

> I cannot see your attached files, but is there any chance this is
> about HID, not USB?

Posted a follow-up message immediately when I realized I forgot to
include the config file :-(.  Yes, it very well *could* be a HID issue.
I was quick to blame it on a deprecated feature that finally got
removed, when this might well have been a "disguised" regression.

> > Per the syslog entries I included in my initial post on this thread, the
> > only difference between the pre- and post- usbfs removal cases seems to
> > be whatever is needed for the input subsystem to see the USB keyboard
> > and mouse.  I see the USB hubs and attached devices getting detected,
> > but whatever "glue" allows the keyboard and mouse to work isn't there,
> > and the input subsystem doesn't emit the expected messages at boot time.
> 
> If you did a 'make oldconfig' on anything prior to -rc5, chances are
> you do not have CONFIG_HID_GENERIC=y in your .config.

That might well be the missing "glue."  I'm building -rc5 as I type
this.  Should have an answer in a few hours.  Thanks for the clue!

--Bob
