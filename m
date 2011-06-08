Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1FHF1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:27:18 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:39233 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1FHF1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:27:17 -0400
Message-ID: <4DEF0822.7070500@freemail.hu>
Date: Wed, 08 Jun 2011 07:26:58 +0200
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Kulikov Vasiliy <segooon@gmail.com>, Endre Kollar <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Ilia Mirkin <imirkin@alum.mit.edu>,
        David Chang <dchang@novell.com>,
        Himanshu Chauhan <hschauhan@nulltrace.org>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: handle length at sysfs show() functions
References: <4DE5CA9F.6010303@freemail.hu> <20110607213418.GB11102@kroah.com>
In-Reply-To: <20110607213418.GB11102@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 178.164.145.104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Wed, Jun 01, 2011 at 07:14:07AM +0200, Németh Márton wrote:
>> The sysfs show() functions shall return the actual content length of
>> the result buffer. According to Documentation/filesystems/sysfs.txt:215
>> the scnprintf() function is preferred.
>>
>> See also the article titled "snprintf() confusion" at
>> http://lwn.net/Articles/69419/ .
>
> [...]
>
> Here we are doing lots of work to try to put more than one value in the
> sysfs file, and return the proper data to the kernel about how big the
> buffer we used.
> 
> That's wrong, and violates the "one value per file" sysfs rule, so that
> should be fixed instead of trying to change the sprintf() call.

As I understand there is a need to change the design here. Currently I
get the following content when vhci-hcd is loaded but not yet used:

$ cat /sys/devices/platform/vhci_hcd/status
prt sta spd bus dev socket           local_busid
000 004 000 000 000 0000000000000000 0-0
001 004 000 000 000 0000000000000000 0-0
002 004 000 000 000 0000000000000000 0-0
003 004 000 000 000 0000000000000000 0-0
004 004 000 000 000 0000000000000000 0-0
005 004 000 000 000 0000000000000000 0-0
006 004 000 000 000 0000000000000000 0-0
007 004 000 000 000 0000000000000000 0-0

The fields are: port, status, speed, device ID, socket pointer and
local busid name. This is too complex for sysfs. Maybe we could extend
the devices file of usbfs with some new rows?

The current output of the devices file already contains some fields
with same name, but I don't have the overview to see whether this
could replace the current /sys/devices/platform/vhci_hcd/status file.

$ cat /proc/bus/usb/devices
[...]

T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  3 Spd=1.5  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0458 ProdID=003a Rev= 1.00
S:  Manufacturer=Genius
S:  Product=Optical Mouse
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=10ms

[...]

Regards,

	Márton Németh

