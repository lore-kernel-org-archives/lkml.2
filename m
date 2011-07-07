Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab1GGHis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:38:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49988 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751284Ab1GGHir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:38:47 -0400
Date: Thu, 7 Jul 2011 08:40:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nathan Royer <nroyer@invensense.com>
Cc: Alan Cox <alan@linux.intel.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Chris Hudson <chudson@kionix.com>,
        eric.andersson@unixphere.com
Subject: Re: [PATCH 01/11] misc: inv_mpu primary header file and README
 file.
Message-ID: <20110707084026.4562ab94@lxorguk.ukuu.org.uk>
In-Reply-To: <592dafb95382604bd514687f7600cebd@mail.gmail.com>
References: <1309486707-1658-1-git-send-email-nroyer@invensense.com>
	<4E0D8E94.5030604@cam.ac.uk>
	<4d61a92a11e5d83a1cb0094441ae5f5e@mail.gmail.com>
	<4E105284.7030209@cam.ac.uk>
	<20110704091658.0d4c8e3f@bob.linux.org.uk>
	<c2189246a279a0e5a1b8599edc94a79a@mail.gmail.com>
	<20110706115430.3745592c@bob.linux.org.uk>
	<592dafb95382604bd514687f7600cebd@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I understand you correctly, you are suggesting that we create two
> drivers for the mpu3050 part.  An MPU (Motion Processing Unit) driver and
> a standalone Gyroscope driver.  The MPU if present would turn each sensor
> (accel, compass, gyro, pressure) into an MPU slave, load and configure the
> firmware, and provide a user space interface for customization and runtime
> communication with the Hideously Complicated Algorithms (HCA's).

Its hard to judge with what has been explained so far but the device
appears to be very different in the two operating modes so it might make
sense to have it as two drivers (or one driver with two very distinct
modes)

> Each sensor driver would have two operating modes, standalone, and slave
> to the MPU trying to re-use as much code as possible.  Current drivers
> that have a standalone interface would need the slave interface added, and
> those that we've written would need the stand alone interface added.

Can the slave interface appears to be an i²c bus too or is the interface
too different (ie could the smart mode create an i²c bus that it uses to
talk to the drivers to configure them for 'smart' mode)

I'm not entirely sure at this point I understand quite how all the pieces
fit together.

Alan
