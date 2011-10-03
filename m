Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab1JCJwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 05:52:08 -0400
Received: from mr.siano-ms.com ([62.0.79.70]:17176 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753964Ab1JCJv4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 05:51:56 -0400
X-Greylist: delayed 726 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Oct 2011 05:51:56 EDT
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: How can LKM store persistent data?
Date: Mon, 3 Oct 2011 11:41:44 +0200
Message-ID: <D945C405928A9949A0F33C69E64A1A3BCD3DB9@s-mail.siano-ms.ent>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: How can LKM store persistent data?
Thread-Index: AcyBsKmKKU1UsLTnQGqEr2IFtf94QQ==
From: "Doron Cohen" <doronc@siano-ms.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am handling Digital TV receiver drivers for Siano Mobile Silicon
chips.
We would like the driver to have some persistent data which can be saved
from one load to another (explanation why is a bit long so it is written
below and you may skip it. 
I know that accessing files from modules is strictly forbidden, but I
couldn't find what the right way to do that is. One way I could think of
is to make a mechanism like request_firmware is using which is making a
device node and have a deamon in userspace fill it in (or write it to a
file) when required. But I am not sure that would be wise for every
module that needs such operation to implement such mechanism on it's
own.
Is there any other way for a module to save some configuration data for
use on the next time the module is loaded?

Now as promised the why:
Our device has some configuration data like DVB standard and operation
mode which is not changes frequently. Currently it can be changed using
module parameters and by ioctl calls. But when the driver is down and up
again (meaning - every restart, sleep, reboot etc.)  the module is back
to the default settings unless the config file is changed which is not
done for most users.
Our users asked us to keep this data persistent, if someone is using
ISDBT he would probably use it forever unless traveling to another
region. So the request is once a mode was set, do not change it on the
next reload just work at that mode until instructed otherwise. Therefore
the driver needs to save this data somehow, and read it when it loads
and work according to it.

Thanks,
Doron

