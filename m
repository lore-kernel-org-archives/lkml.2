Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab1LVSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 13:16:28 -0500
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:62843 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1LVSQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 13:16:26 -0500
X-Greylist: delayed 3654 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 13:16:25 EST
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Dec 2011 11:15:06 -0600
Subject: Driver core support for early platform devices
Thread-Topic: Driver core support for early platform devices
Thread-Index: AczAzUETYsXq7yfmQBKD5IrICl66oA==
Message-ID: <0282FD61-7E73-45CE-8EC8-32BF411C7619@boeing.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm tinkering with some improvements to the way that OpenPIC/MPIC are
detected and loaded on PowerPC platforms, and it seems like I am trying
to use the driver model before it is fully initialized.

In particular, it seems like it should be possible to simply declare an
OpenPIC in the device-tree and have it automatically bound to a platform
driver declaring the right OpenFirmware match strings.

Unfortunately, it needs to be bound by init_IRQ() time, while the driver
model does not get initialized until much later (after the scheduler is
up and running).

As far as I can tell, there seem to be 2 possible approaches to making
that possible:

(1) Split the driver-model initialization into "early" and "late" phases
    so that drivers can be registered and devices probed very early on
    and then replay the necessary scheduler-dependent things after the
    system is mostly started up (IE: devtmpfs, etc).

(2) Create a separate mini-platform-driver-model which can create and
    probe platform devices early on and then automatically register them
    properly on the platform_bus once the driver model comes up.

Do you think this is the right approach?  Is there any existing work
being done to support either model?

Thanks for your help!

Cheers,
Kyle Moffett

--
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/

