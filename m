Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1AVWA0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:00:26 -0500
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:51600 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752476Ab1AVWAZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:00:25 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Jan 2011 17:00:24 EST
X-SpamScore: -4
X-BigFish: VPS-4(zz4015Lzz1202hzzz2dh95h668h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: console problem?, close(2) hangs /sbin/init
Date: Sat, 22 Jan 2011 14:45:09 -0700
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: console problem?, close(2) hangs /sbin/init
Thread-Index: Acu6faQMQ9P6a7G0TZ6dFVQ45qRDAQ==
From: John Linn <John.Linn@xilinx.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 22 Jan 2011 21:45:12.0165 (UTC) FILETIME=[A5919150:01CBBA7D]
X-RCIS-Action: ALLOW
Message-ID: <7110b8bd-1411-4a92-81b7-1a76f5d5cb65@SG2EHSMHS005.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a kernel that runs fine with a busybox root file system using
inittab.  When I move to a non-busybox init (sysvinit), I see init
hanging when doing a close of standard error very early when it starts.
I have debugged it with GDB but not found the source of the hang as it's
in the kernel it appears.

To debug this, I use init=/bin/sh on the kernel command line, then exec
init to start it. The same root file system works on another board with
a different kernel.  I have also noticed that building init with
INITDEBUG on so that it forks for debugging makes it work fine. This
seems to indicate the device nodes are all fine to me.

It seems related to PID 1 and the console device.

Adding debug to the kernel in sys_close() shows it hanging in
filp_close() and I'm still digging more (maybe locking issue). The
console is a serial device with a newer driver which I suspected to be
the issue, but can't see anything wrong.

Any hints or similar problems seen would be much appreciated.
Thanks,
John


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


