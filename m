Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab1GAOkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 10:40:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43775 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756689Ab1GAOkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 10:40:35 -0400
Date: Fri, 1 Jul 2011 15:41:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chris Wolfe <cwolfe@chromium.org>
Cc: Alan Cox <alan@linux.intel.com>, Nathan Royer <nroyer@invensense.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 11/11] misc: Add slave driver for bma085 pressure sensor
Message-ID: <20110701154150.0ac303a3@lxorguk.ukuu.org.uk>
In-Reply-To: <CAN_12A8Za7r92=r3JHx3R=AwAA7xk6=NVVMiSp68HPatb1G3hg@mail.gmail.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<1309486707-1658-11-git-send-email-nroyer@invensense.com>
	<20110701085604.0aabd6f1@bob.linux.org.uk>
	<CAN_12A8Za7r92=r3JHx3R=AwAA7xk6=NVVMiSp68HPatb1G3hg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just to field this quickly, since I've been playing with the hardware

(Ditto)

> Part of the reason I got started on the KXTF9 driver was to try and
> understand how a normal kernel driver could cope with the "here and
> gone again" behavior of being on the MPU's secondary bus.

It's a hot pluggable bus - no different to an i2c bus on a hot pluggable
device. 

I would guess however that if you knew the device was going to be used for
the mpu3050 only you'd not add the "slave" devices in your platform data
in the first place as well so they didn't bounce in and out and you'd
probably teach the mpu3050 code to not create the bus if it was then
going to destroy it again a moment later.

> The other note that may not have been made explicit yet is that the
> 3050 will happily provide unprocessed gyro and slave data without
> firmware loaded. The firmware sets up some additional processing
> capabilities of the chip, which are used by InvenSense's user-space
> products.

Yes - and the current mpu3050 driver provides just these interfaces.

Of the other stuff the slave drivers seem to be no problem as standard
i²c bus devices, the MPU mode may depend upon whether there is open
documentation, applying the standards we apply to everything else. That
is "can someone write their own tools to use that interface based upon the
documentation/source code examples available".

Eg for the ektf driver which is pending the interface is all documented
and provides rectangles of pressure data but you'll have to go write
your own gesture recognizer parts if you want to do clever stuff with it.

Alan
