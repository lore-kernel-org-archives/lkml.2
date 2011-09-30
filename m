Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab1I3Jfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:35:32 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:46782 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634Ab1I3Jfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:35:30 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E858F5A.5000901@cam.ac.uk>
Date: Fri, 30 Sep 2011 10:43:54 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110901 Thunderbird/6.0
MIME-Version: 1.0
To: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: IIO (+ more general?) Error condition handling (e.g. wire fell out
 errors)
X-Enigmail-Version: 1.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure how general this is, hence sent to LKML and IIO.

Some of the devices we have can produce interrupts indicating
that everything has gone horribly wrong. Sometimes this is
also embedded in the main data stream.

The best examples are all the 'wonderful' ways the ad2s1210 resolver
can go wrong.  None of these would be expected to be part of normal
operating conditions.

So, the question is - do we want these to go through our main
events stream?  They are weird and wonderful and often don't
align well with our existing event codes.  Loss of data error
for example (a wire came out).  Others could possibly be made
to fit but that would loose some of the semantics.  Loss of
tracking could be a rate of change threshold event, but it
really is meant to tell you the data could be garbage.

So three options come to mind:

1) Have a magic set of event codes for device class specific
fault events and push through our main event path.  For reference of
non IIO types - that is an anon file descriptor obtained by an
ioctl on the devices chrdev.  Events are a simple timestamp / eventcode
pair.

2)  Add another anon file that you get via an ioctl as a separate
event reporting channel. We then define a big list of error codes
without aiming for any real structure.  Drivers would then need to
document what they can throw out (preferably under sysfs?)

3) Consider these out of band (from the out of band event data)
and look at other options for reporting them.

Is there anything general out there for reporting hardware failures
that would be appropriate?  Sometime these conditions are the sort
of thing that should cause a siren to go off.
They might be sensor failure.... or they might mean you have
a runaway train heading for a station... 

(p.s. I hope no one is using the current driver for trains, though
that might explain British trains...)

Thanks,

Jonathan
