Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2GAUlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 16:41:14 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:33685 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2GAUlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:41:12 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuZLANm08E9V5qg+PGdsb2JhbABFihWsRBkBAQEBHhkNJ4IYAQEEATocIwULCAMOOBQlChqIGQm6dRSQYWADlTOBE4RTjH8
X-IronPort-AV: E=Sophos;i="4.77,506,1336341600"; 
   d="scan'208";a="73038580"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 1 Jul 2012 22:41:18 +0200
To: Bob Tracy <rct@gherkin.frus.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Message-ID: <20120701204118.GA1018@polaris.bitmath.org>
References: <20120628131651.GA14492@gherkin.frus.com>
 <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com>
 <20120629033600.GA3591@gherkin.frus.com>
 <20120630033519.GA4792@kroah.com>
 <20120701201411.GB8603@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701201411.GB8603@gherkin.frus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I knew what was missing, I'd create it and be done with it.  Here's
> the scenario...  Kernel built from the standard kernel.org tree.  All
> drivers needed at boot time are built-in, except now there's probably
> something missing on the USB side of things.  No initrd.

Are modules turned off as well?

> I'll attach my
> config file on the good chance someone will spot the missing piece(s)
> quickly.  Note that the DEVTMPFS options are disabled in this config,
> but I'll reenable them if required.  When I said devtmpfs "didn't help,"
> what I meant was, by itself relative to my current configuration, turning
> on devtmpfs made no difference.

I cannot see your attached files, but is there any chance this is
about HID, not USB?

> Per the syslog entries I included in my initial post on this thread, the
> only difference between the pre- and post- usbfs removal cases seems to
> be whatever is needed for the input subsystem to see the USB keyboard
> and mouse.  I see the USB hubs and attached devices getting detected,
> but whatever "glue" allows the keyboard and mouse to work isn't there,
> and the input subsystem doesn't emit the expected messages at boot time.

If you did a 'make oldconfig' on anything prior to -rc5, chances are
you do not have CONFIG_HID_GENERIC=y in your .config.

Henrik
