Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab1DFOUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:20:08 -0400
Received: from gretna.indigovision.com ([62.7.85.227]:32590 "EHLO
	gretna.indigovision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1DFOUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:20:07 -0400
From: Bruce Stenning <b.stenning@indigovision.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Bruce Stenning <b.stenning@indigovision.com>
Date: Wed, 6 Apr 2011 15:20:04 +0100
Subject: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Topic: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Thread-Index: Acv0Zblolvio1ZVFTIOocFpuSxH+GQ==
Message-ID: <C1438B59050E1B4C9482FF3266AD6BA32C7493557A@gretna.indigovision.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: 3DI= ADuh ASva CkhN Cxtk DDMq DD+J D/ft FTuB FhdC F+mR
 GUsh HOA2 HXYg Ha3i
 IbmI;1;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{D71ABDA5-4E19-4E19-8A4E-0E6A67384E8E};YgAuAHMAdABlAG4AbgBpAG4AZwBAAGkAbgBkAGkAZwBvAHYAaQBzAGkAbwBuAC4AYwBvAG0A;Wed,
 06 Apr 2011 14:20:04
 GMT;cwBhAHQAYQBfAG0AdgAgAHAAbwByAHQAIABsAG8AYwBrAHUAcAAgAG8AbgAgAGgAbwB0AHAAbAB1AGcAIAAoAGsAZQByAG4AZQBsACAAMgAuADYALgAzADgALgAyACkA
x-cr-puzzleid: {D71ABDA5-4E19-4E19-8A4E-0E6A67384E8E}
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have a bespoke platform utilising a Marvell MV88SX6041 SATA controller on which we have been running Linux 2.6.26 and using the sata_mv driver.

We have noticed problems with SATA ports occasionally locking up (on hotplug events) and remaining unresponsive.  The normal kernel logging that occurs on hotplug events is no longer emitted for the locked ports (but will be emitted for the other sata ports that have not exhibited the problem.)  The disks attached to the locked ports are completely unresponsive.  The condition can be cleared by removing the sata_mv kernel module from memory and reloading it, after which the kernel logging becomes active (and the disks are usable) for all ports.

The following changeset was seen as a strong candidate for addressing this problem:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=933cb8e5fcdebd4b666165e3f039f814d62b0e52

We are now in the process of upgrading to the stable 2.6.38.2 kernel release, but initial testing of this on our platform exhibits the same hotplug behaviour.  Hotplug is possible, but occasionally the ports will lock up and not be responsive until sata_mv is removed and reinstalled.  Other than this, the new kernel and driver seem to be operating normally.

Has this problem been observed elsewhere with kernels that include the above patch?  Please CC me in replies.

Kind Regards,

Bruce Stenning,
IndigoVision,
b <dot> stenning <at> indigovision <dot> com


Latest News at: http://www.indigovision.com/news2011.php
