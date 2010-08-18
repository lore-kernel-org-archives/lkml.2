Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0HRTUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 15:20:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54958 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0HRTUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 15:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=qykCKDB2wcPOWVR/KBix23aSyqd26Ph7wZyWRVMp/vvV3BR4uFklxTfBXl3nYj0O9B
         WJDPGabHJItRIc0l+iMI2fQR+ZoKzGrv3jX5owUDBYeO8Xagqpn5MxC93fYQbKi7n8c8
         FNxnrL6NVjEKyZWvhULI+JC/R98DhpcS+8SUI=
MIME-Version: 1.0
Date: Wed, 18 Aug 2010 12:20:48 -0700
Message-ID: <AANLkTinNw9859ihV4VM=x7sQuF0aoSw1asc0_EujXXrC@mail.gmail.com>
Subject: 2.6.36-rc1 -- BUG: kmalloc-4096: Object already free -- INFO:
 Allocated in wireless_send_event+0x21d/0x344
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Jaroslav Kysela <perex@perex.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is this indicative of a kernel bug or just problems with userspace apps?

[   44.455666] BUG kmalloc-4096: Object already free
[   44.455670] -----------------------------------------------------------------------------
[   44.455673]
[   44.455685] INFO: Allocated in wireless_send_event+0x21d/0x344
age=0 cpu=1 pid=635
[   44.455694] INFO: Freed in skb_release_data+0xbc/0xc1 age=0 cpu=0 pid=1571
[   44.455700] INFO: Slab 0xffffea000459c940 objects=7 used=4
fp=0xffff88013e39d168 flags=0x80000000000040c1
[   44.455705] INFO: Object 0xffff88013e39d168 @offset=20840
fp=0xffff88013e39c120
[   44.455707]
[   44.455713] Bytes b4 0xffff88013e39d158:  71 06 ff ff 00 00 00 00
5a 5a 5a 5a 5a 5a 5a 5a q.��....ZZZZZZZZ
[   44.455745]   Object 0xffff88013e39d168:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455775]   Object 0xffff88013e39d178:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455805]   Object 0xffff88013e39d188:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455835]   Object 0xffff88013e39d198:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455865]   Object 0xffff88013e39d1a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455895]   Object 0xffff88013e39d1b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455926]   Object 0xffff88013e39d1c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455956]   Object 0xffff88013e39d1d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.455986]   Object 0xffff88013e39d1e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456016]   Object 0xffff88013e39d1f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456046]   Object 0xffff88013e39d208:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456076]   Object 0xffff88013e39d218:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456106]   Object 0xffff88013e39d228:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456136]   Object 0xffff88013e39d238:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456166]   Object 0xffff88013e39d248:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456196]   Object 0xffff88013e39d258:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456225]   Object 0xffff88013e39d268:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456255]   Object 0xffff88013e39d278:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456285]   Object 0xffff88013e39d288:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456315]   Object 0xffff88013e39d298:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456345]   Object 0xffff88013e39d2a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456375]   Object 0xffff88013e39d2b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456405]   Object 0xffff88013e39d2c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456435]   Object 0xffff88013e39d2d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456464]   Object 0xffff88013e39d2e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456494]   Object 0xffff88013e39d2f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456524]   Object 0xffff88013e39d308:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456554]   Object 0xffff88013e39d318:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456584]   Object 0xffff88013e39d328:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456614]   Object 0xffff88013e39d338:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456644]   Object 0xffff88013e39d348:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456674]   Object 0xffff88013e39d358:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456704]   Object 0xffff88013e39d368:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456733]   Object 0xffff88013e39d378:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456763]   Object 0xffff88013e39d388:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456793]   Object 0xffff88013e39d398:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456823]   Object 0xffff88013e39d3a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456852]   Object 0xffff88013e39d3b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456882]   Object 0xffff88013e39d3c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456912]   Object 0xffff88013e39d3d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456942]   Object 0xffff88013e39d3e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.456974]   Object 0xffff88013e39d3f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457004]   Object 0xffff88013e39d408:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457034]   Object 0xffff88013e39d418:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457064]   Object 0xffff88013e39d428:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457094]   Object 0xffff88013e39d438:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457124]   Object 0xffff88013e39d448:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457153]   Object 0xffff88013e39d458:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457183]   Object 0xffff88013e39d468:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457213]   Object 0xffff88013e39d478:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457243]   Object 0xffff88013e39d488:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457273]   Object 0xffff88013e39d498:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457303]   Object 0xffff88013e39d4a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457333]   Object 0xffff88013e39d4b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457363]   Object 0xffff88013e39d4c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457393]   Object 0xffff88013e39d4d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457423]   Object 0xffff88013e39d4e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457453]   Object 0xffff88013e39d4f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457482]   Object 0xffff88013e39d508:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457512]   Object 0xffff88013e39d518:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457542]   Object 0xffff88013e39d528:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457572]   Object 0xffff88013e39d538:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457602]   Object 0xffff88013e39d548:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457632]   Object 0xffff88013e39d558:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457662]   Object 0xffff88013e39d568:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457692]   Object 0xffff88013e39d578:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457721]   Object 0xffff88013e39d588:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457751]   Object 0xffff88013e39d598:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457781]   Object 0xffff88013e39d5a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457811]   Object 0xffff88013e39d5b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457841]   Object 0xffff88013e39d5c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457871]   Object 0xffff88013e39d5d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457901]   Object 0xffff88013e39d5e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457930]   Object 0xffff88013e39d5f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457960]   Object 0xffff88013e39d608:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.457990]   Object 0xffff88013e39d618:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458020]   Object 0xffff88013e39d628:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458050]   Object 0xffff88013e39d638:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458080]   Object 0xffff88013e39d648:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458109]   Object 0xffff88013e39d658:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458139]   Object 0xffff88013e39d668:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458169]   Object 0xffff88013e39d678:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458199]   Object 0xffff88013e39d688:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458229]   Object 0xffff88013e39d698:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458258]   Object 0xffff88013e39d6a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458288]   Object 0xffff88013e39d6b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458318]   Object 0xffff88013e39d6c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458348]   Object 0xffff88013e39d6d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458378]   Object 0xffff88013e39d6e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458408]   Object 0xffff88013e39d6f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458438]   Object 0xffff88013e39d708:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458468]   Object 0xffff88013e39d718:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458498]   Object 0xffff88013e39d728:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458527]   Object 0xffff88013e39d738:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458558]   Object 0xffff88013e39d748:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458587]   Object 0xffff88013e39d758:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458617]   Object 0xffff88013e39d768:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458647]   Object 0xffff88013e39d778:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458677]   Object 0xffff88013e39d788:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458707]   Object 0xffff88013e39d798:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458736]   Object 0xffff88013e39d7a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458766]   Object 0xffff88013e39d7b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458796]   Object 0xffff88013e39d7c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458826]   Object 0xffff88013e39d7d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458856]   Object 0xffff88013e39d7e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458886]   Object 0xffff88013e39d7f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458916]   Object 0xffff88013e39d808:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458945]   Object 0xffff88013e39d818:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.458975]   Object 0xffff88013e39d828:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459005]   Object 0xffff88013e39d838:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459035]   Object 0xffff88013e39d848:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459065]   Object 0xffff88013e39d858:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459094]   Object 0xffff88013e39d868:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459124]   Object 0xffff88013e39d878:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459153]   Object 0xffff88013e39d888:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459183]   Object 0xffff88013e39d898:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459212]   Object 0xffff88013e39d8a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459242]   Object 0xffff88013e39d8b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459272]   Object 0xffff88013e39d8c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459302]   Object 0xffff88013e39d8d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459331]   Object 0xffff88013e39d8e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d8f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d908:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d918:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d928:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d938:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d948:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d958:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d968:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d978:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d988:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d998:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d9a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d9b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d9c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d9d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d9e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39d9f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39da98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39daa8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dab8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dac8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dad8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dae8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39daf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39db98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dba8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dbb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dbc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dbd8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dbe8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dbf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dc98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dca8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dcb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dcc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dcd8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dce8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dcf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dd98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dda8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39ddb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39ddc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39ddd8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dde8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39ddf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39de98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dea8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39deb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dec8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39ded8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dee8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39def8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39df98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dfa8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dfb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dfc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dfd8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dfe8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39dff8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e008:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e018:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e028:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e038:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e048:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e058:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e068:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e078:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e088:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e098:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e0a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e0b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e0c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e0d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e0e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e0f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e108:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e118:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e128:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e138:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e148:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.459358]   Object 0xffff88013e39e158:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
[   44.459358]  Redzone 0xffff88013e39e168:  bb bb bb bb bb bb bb bb
                      ��������
[   44.459358]  Padding 0xffff88013e39e1a8:  5a 5a 5a 5a 5a 5a 5a 5a
                      ZZZZZZZZ
[   44.459358] Pid: 1510, comm: avahi-daemon Not tainted 2.6.36-rc1 #4
[   44.459358] Call Trace:
[   44.459358]  [<ffffffff810b5258>] print_trailer+0x12e/0x137
[   44.459358]  [<ffffffff812a4094>] ? skb_release_data+0xbc/0xc1
[   44.459358]  [<ffffffff810b5296>] object_err+0x35/0x3d
[   44.459358]  [<ffffffff810b69d0>] __slab_free+0x192/0x22b
[   44.459358]  [<ffffffff810b7120>] kfree+0xbb/0xe5
[   44.459358]  [<ffffffff812a4094>] ? skb_release_data+0xbc/0xc1
[   44.459358]  [<ffffffff812a4094>] skb_release_data+0xbc/0xc1
[   44.459358]  [<ffffffff812a3d0e>] __kfree_skb+0x19/0x7c
[   44.459358]  [<ffffffff812a3dc3>] kfree_skb+0x28/0x2a
[   44.459358]  [<ffffffff812c2de6>] netlink_recvmsg+0xe3/0x325
[   44.459358]  [<ffffffff8129f84e>] ? rcu_read_unlock+0x21/0x23
[   44.459358]  [<ffffffff8129aaea>] __sock_recvmsg_nosec+0x65/0x6e
[   44.459358]  [<ffffffff8129c016>] __sock_recvmsg+0x49/0x54
[   44.459358]  [<ffffffff8129c3c7>] sock_recvmsg+0xa6/0xbf
[   44.459358]  [<ffffffff81063eae>] ? lock_release_non_nested+0x9d/0x220
[   44.459358]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.459358]  [<ffffffff8109f6d0>] ? might_fault+0xac/0xb3
[   44.459358]  [<ffffffff812a5bda>] ? copy_from_user+0x2a/0x2c
[   44.459358]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.459358]  [<ffffffff812a5fac>] ? verify_iovec+0x4f/0x8f
[   44.459358]  [<ffffffff8129c177>] __sys_recvmsg+0x156/0x241
[   44.459358]  [<ffffffff810cb2da>] ? pollwake+0x0/0x4f
[   44.459358]  [<ffffffff810bcc43>] ? do_sync_read+0xc6/0x103
[   44.459358]  [<ffffffff810bdcf9>] ? fcheck_files+0x98/0xdc
[   44.459358]  [<ffffffff810bdd95>] ? fget_light+0x35/0x96
[   44.459358]  [<ffffffff8129c856>] sys_recvmsg+0x3d/0x5b
[   44.459358]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[   44.459358] FIX kmalloc-4096: Object at 0xffff88013e39d168 not freed
[   44.471711] =============================================================================
[   44.471719] BUG skbuff_head_cache: Padding overwritten.
0xffff88013c92cf80-0xffff88013c92cf80
[   44.471724] -----------------------------------------------------------------------------
[   44.471727]
[   44.471733] INFO: Slab 0xffffea00045401a0 objects=12 used=2
fp=0xffff88013c92cc80 flags=0x80000000000000c1
[   44.471741] Pid: 1510, comm: avahi-daemon Not tainted 2.6.36-rc1 #4
[   44.471745] Call Trace:
[   44.471754]  [<ffffffff810b5108>] slab_err+0xa5/0xc7
[   44.471763]  [<ffffffff81190801>] ? debug_check_no_obj_freed+0x65/0x1d3
[   44.471771]  [<ffffffff810322d4>] ? get_parent_ip+0x11/0x41
[   44.471778]  [<ffffffff810322d4>] ? get_parent_ip+0x11/0x41
[   44.471786]  [<ffffffff810b557a>] slab_pad_check+0xcd/0x11f
[   44.471793]  [<ffffffff812a3d6d>] ? __kfree_skb+0x78/0x7c
[   44.471800]  [<ffffffff810b5654>] check_slab+0x88/0x8f
[   44.471807]  [<ffffffff810b690f>] __slab_free+0xd1/0x22b
[   44.471815]  [<ffffffff810b6af8>] kmem_cache_free+0x8f/0xb9
[   44.471822]  [<ffffffff812a3d6d>] ? __kfree_skb+0x78/0x7c
[   44.471829]  [<ffffffff812a3d6d>] __kfree_skb+0x78/0x7c
[   44.471836]  [<ffffffff812a3d99>] consume_skb+0x28/0x2a
[   44.471843]  [<ffffffff812a6be0>] skb_free_datagram+0x14/0x3a
[   44.471851]  [<ffffffff812c2eed>] netlink_recvmsg+0x1ea/0x325
[   44.471860]  [<ffffffff8129aaea>] __sock_recvmsg_nosec+0x65/0x6e
[   44.471867]  [<ffffffff8129c016>] __sock_recvmsg+0x49/0x54
[   44.471875]  [<ffffffff8129c3c7>] sock_recvmsg+0xa6/0xbf
[   44.471882]  [<ffffffff81063eae>] ? lock_release_non_nested+0x9d/0x220
[   44.471891]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.471899]  [<ffffffff8109f6d0>] ? might_fault+0xac/0xb3
[   44.471906]  [<ffffffff812a5bda>] ? copy_from_user+0x2a/0x2c
[   44.471913]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.471920]  [<ffffffff812a5fac>] ? verify_iovec+0x4f/0x8f
[   44.471928]  [<ffffffff8129c177>] __sys_recvmsg+0x156/0x241
[   44.471935]  [<ffffffff810cb2da>] ? pollwake+0x0/0x4f
[   44.471943]  [<ffffffff810bcc43>] ? do_sync_read+0xc6/0x103
[   44.471951]  [<ffffffff810bdcf9>] ? fcheck_files+0x98/0xdc
[   44.471958]  [<ffffffff810bdd95>] ? fget_light+0x35/0x96
[   44.471965]  [<ffffffff8129c856>] sys_recvmsg+0x3d/0x5b
[   44.471974]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[   44.471980]  Padding 0xffff88013c92ce81:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472012]  Padding 0xffff88013c92ce91:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b a5 bb kkkkkkkkkkkkkk��
[   44.472012]  Padding 0xffff88013c92cea1:  bb bb bb bb bb bb bb 40
c1 92 3c 01 88 ff ff 06 �������@�.<..��.
[   44.472012]  Padding 0xffff88013c92ceb1:  41 2a 81 ff ff ff ff 01
00 00 00 7b 02 00 00 71 A*.����....{...q
[   44.472012]  Padding 0xffff88013c92cec1:  06 ff ff 00 00 00 00 6d
3d 2a 81 ff ff ff ff 00 .��....m=*.����.
[   44.472012]  Padding 0xffff88013c92ced1:  00 00 00 23 06 00 00 71
06 ff ff 00 00 00 00 5a ...#...q.��....Z
[   44.472012]  Padding 0xffff88013c92cee1:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cef1:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf01:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf11:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf21:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf31:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf41:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf51:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf61:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472012]  Padding 0xffff88013c92cf71:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 59 ZZZZZZZZZZZZZZZY
[   44.472012] FIX skbuff_head_cache: Restoring
0xffff88013c92ce81-0xffff88013c92cf80=0x5a
[   44.472012]
[   44.472642] =============================================================================
[   44.472642] BUG skbuff_head_cache: Freechain corrupt
[   44.472642] -----------------------------------------------------------------------------
[   44.472642]
[   44.472642] INFO: Allocated in 0x5a5a5a5a5a5a5a5a
age=11936128522577554459 cpu=1515870810 pid=1515870810
[   44.472642] INFO: Freed in 0x5a5a5a5a5a5a5a5a
age=11936128522577554459 cpu=1515870810 pid=1515870810
[   44.472642] INFO: Slab 0xffffea00045401a0 objects=12 used=2
fp=0xffff88013c92cc80 flags=0x80000000000000c1
[   44.472642] INFO: Object 0xffff88013c92cdc0 @offset=3520
fp=0x5a5a5a5a5a5a5a5a
[   44.472642]
[   44.472642] Bytes b4 0xffff88013c92cdb0:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472642]   Object 0xffff88013c92cdc0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92cdd0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92cde0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92cdf0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce00:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce10:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce20:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce30:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce40:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce50:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce60:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce70:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   44.472642]   Object 0xffff88013c92ce80:  6b 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a kZZZZZZZZZZZZZZZ
[   44.472642]   Object 0xffff88013c92ce90:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472642]  Redzone 0xffff88013c92cea0:  5a 5a 5a 5a 5a 5a 5a 5a
                      ZZZZZZZZ
[   44.472642]  Padding 0xffff88013c92cee0:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472642]  Padding 0xffff88013c92cef0:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   44.472642] Pid: 1510, comm: avahi-daemon Not tainted 2.6.36-rc1 #4
[   44.472642] Call Trace:
[   44.472642]  [<ffffffff810b5258>] print_trailer+0x12e/0x137
[   44.472642]  [<ffffffff810b5296>] object_err+0x35/0x3d
[   44.472642]  [<ffffffff810b530a>] on_freelist+0x6c/0x19d
[   44.472642]  [<ffffffff812a3d6d>] ? __kfree_skb+0x78/0x7c
[   44.472642]  [<ffffffff810b6949>] __slab_free+0x10b/0x22b
[   44.472642]  [<ffffffff810b6af8>] kmem_cache_free+0x8f/0xb9
[   44.472642]  [<ffffffff812a3d6d>] ? __kfree_skb+0x78/0x7c
[   44.472642]  [<ffffffff812a3d6d>] __kfree_skb+0x78/0x7c
[   44.472642]  [<ffffffff812a3d99>] consume_skb+0x28/0x2a
[   44.472642]  [<ffffffff812a6be0>] skb_free_datagram+0x14/0x3a
[   44.472642]  [<ffffffff812c2eed>] netlink_recvmsg+0x1ea/0x325
[   44.472642]  [<ffffffff8129aaea>] __sock_recvmsg_nosec+0x65/0x6e
[   44.472642]  [<ffffffff8129c016>] __sock_recvmsg+0x49/0x54
[   44.472642]  [<ffffffff8129c3c7>] sock_recvmsg+0xa6/0xbf
[   44.472642]  [<ffffffff81063eae>] ? lock_release_non_nested+0x9d/0x220
[   44.472642]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.472642]  [<ffffffff8109f6d0>] ? might_fault+0xac/0xb3
[   44.472642]  [<ffffffff812a5bda>] ? copy_from_user+0x2a/0x2c
[   44.472642]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.472642]  [<ffffffff812a5fac>] ? verify_iovec+0x4f/0x8f
[   44.472642]  [<ffffffff8129c177>] __sys_recvmsg+0x156/0x241
[   44.472642]  [<ffffffff810cb2da>] ? pollwake+0x0/0x4f
[   44.472642]  [<ffffffff810bcc43>] ? do_sync_read+0xc6/0x103
[   44.472642]  [<ffffffff810bdcf9>] ? fcheck_files+0x98/0xdc
[   44.472642]  [<ffffffff810bdd95>] ? fget_light+0x35/0x96
[   44.472642]  [<ffffffff8129c856>] sys_recvmsg+0x3d/0x5b
[   44.472642]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[   44.472642] =============================================================================
[   44.472642] BUG skbuff_head_cache: Wrong object count. Counter is 2
but counted were 9
[   44.472642] -----------------------------------------------------------------------------
[   44.472642]
[   44.472642] INFO: Slab 0xffffea00045401a0 objects=12 used=2
fp=0xffff88013c92cc80 flags=0x80000000000000c1
[   44.472642] Pid: 1510, comm: avahi-daemon Not tainted 2.6.36-rc1 #4
[   44.472642] Call Trace:
[   44.472642]  [<ffffffff810b5108>] slab_err+0xa5/0xc7
[   44.472642]  [<ffffffff810b5407>] on_freelist+0x169/0x19d
[   44.472642]  [<ffffffff812a3d6d>] ? __kfree_skb+0x78/0x7c
[   44.472642]  [<ffffffff810b6949>] __slab_free+0x10b/0x22b
[   44.472642]  [<ffffffff810b6af8>] kmem_cache_free+0x8f/0xb9
[   44.472642]  [<ffffffff812a3d6d>] ? __kfree_skb+0x78/0x7c
[   44.472642]  [<ffffffff812a3d6d>] __kfree_skb+0x78/0x7c
[   44.472642]  [<ffffffff812a3d99>] consume_skb+0x28/0x2a
[   44.472642]  [<ffffffff812a6be0>] skb_free_datagram+0x14/0x3a
[   44.472642]  [<ffffffff812c2eed>] netlink_recvmsg+0x1ea/0x325
[   44.472642]  [<ffffffff8129aaea>] __sock_recvmsg_nosec+0x65/0x6e
[   44.472642]  [<ffffffff8129c016>] __sock_recvmsg+0x49/0x54
[   44.472642]  [<ffffffff8129c3c7>] sock_recvmsg+0xa6/0xbf
[   44.472642]  [<ffffffff81063eae>] ? lock_release_non_nested+0x9d/0x220
[   44.472642]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.472642]  [<ffffffff8109f6d0>] ? might_fault+0xac/0xb3
[   44.472642]  [<ffffffff812a5bda>] ? copy_from_user+0x2a/0x2c
[   44.472642]  [<ffffffff8109f687>] ? might_fault+0x63/0xb3
[   44.472642]  [<ffffffff812a5fac>] ? verify_iovec+0x4f/0x8f
[   44.472642]  [<ffffffff8129c177>] __sys_recvmsg+0x156/0x241
[   44.472642]  [<ffffffff810cb2da>] ? pollwake+0x0/0x4f
[   44.472642]  [<ffffffff810bcc43>] ? do_sync_read+0xc6/0x103
[   44.472642]  [<ffffffff810bdcf9>] ? fcheck_files+0x98/0xdc
[   44.472642]  [<ffffffff810bdd95>] ? fget_light+0x35/0x96
[   44.472642]  [<ffffffff8129c856>] sys_recvmsg+0x3d/0x5b
[   44.472642]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[   44.472642] FIX skbuff_head_cache: Object count adjusted.
[   45.451657] =============================================================================
[   45.451666] BUG skbuff_head_cache: Redzone overwritten
[   45.451671] -----------------------------------------------------------------------------
[   45.451673]
[   45.451678] INFO: 0xffff88013c92cea0-0xffff88013c92cea7. First byte
0x5a instead of 0xbb
[   45.451699] INFO: Allocated in 0x5a5a5a5a5a5a5a5a
age=11936128522577554704 cpu=1515870810 pid=1515870810
[   45.451707] INFO: Freed in 0x5a5a5a5a5a5a5a5a
age=11936128522577554704 cpu=1515870810 pid=1515870810
[   45.451713] INFO: Slab 0xffffea00045401a0 objects=12 used=11
fp=0xffff88013c92cdc0 flags=0x80000000000000c1
[   45.451719] INFO: Object 0xffff88013c92cdc0 @offset=3520 fp=0x(null)
[   45.451721]
[   45.451725] Bytes b4 0xffff88013c92cdb0:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   45.451757]   Object 0xffff88013c92cdc0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.451789]   Object 0xffff88013c92cdd0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.451820]   Object 0xffff88013c92cde0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.451852]   Object 0xffff88013c92cdf0:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.451884]   Object 0xffff88013c92ce00:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.451916]   Object 0xffff88013c92ce10:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.451948]   Object 0xffff88013c92ce20:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.451980]   Object 0xffff88013c92ce30:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.452011]   Object 0xffff88013c92ce40:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.452042]   Object 0xffff88013c92ce50:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.452074]   Object 0xffff88013c92ce60:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.452105]   Object 0xffff88013c92ce70:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   45.452136]   Object 0xffff88013c92ce80:  6b 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a kZZZZZZZZZZZZZZZ
[   45.452168]   Object 0xffff88013c92ce90:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   45.452199]  Redzone 0xffff88013c92cea0:  5a 5a 5a 5a 5a 5a 5a 5a
                      ZZZZZZZZ
[   45.452229]  Padding 0xffff88013c92cee0:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   45.452261]  Padding 0xffff88013c92cef0:  5a 5a 5a 5a 5a 5a 5a 5a
5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
[   45.452294] Pid: 1492, comm: dbus-daemon Not tainted 2.6.36-rc1 #4
[   45.452298] Call Trace:
[   45.452310]  [<ffffffff810b5258>] print_trailer+0x12e/0x137
[   45.452317]  [<ffffffff810b5714>] check_bytes_and_report+0xb9/0xfd
[   45.452324]  [<ffffffff810b57ae>] check_object+0x56/0x19f
[   45.452331]  [<ffffffff810b6fbb>] __slab_alloc+0x404/0x4ae
[   45.452340]  [<ffffffff812a4106>] ? __alloc_skb+0x3d/0x126
[   45.452346]  [<ffffffff812a4106>] ? __alloc_skb+0x3d/0x126
[   45.452353]  [<ffffffff810b73a4>] kmem_cache_alloc+0x70/0xc1
[   45.452359]  [<ffffffff812a4106>] __alloc_skb+0x3d/0x126
[   45.452366]  [<ffffffff8129fe79>] sock_alloc_send_pskb+0xd1/0x2fa
[   45.452373]  [<ffffffff812a0867>] ? cred_to_ucred+0x68/0x73
[   45.452379]  [<ffffffff812a00b2>] sock_alloc_send_skb+0x10/0x12
[   45.452387]  [<ffffffff8130f995>] unix_stream_sendmsg+0x11e/0x2c6
[   45.452395]  [<ffffffff8129bfc1>] __sock_sendmsg+0x66/0x72
[   45.452402]  [<ffffffff8129e2dd>] ? sock_aio_write+0x0/0xf7
[   45.452409]  [<ffffffff8129e3be>] sock_aio_write+0xe1/0xf7
[   45.452417]  [<ffffffff810bca3b>] do_sync_readv_writev+0xbc/0xfb
[   45.452425]  [<ffffffff8109f6d0>] ? might_fault+0xac/0xb3
[   45.452432]  [<ffffffff810bc7f6>] ? copy_from_user+0x2a/0x2c
[   45.452440]  [<ffffffff8115eeea>] ? security_file_permission+0x29/0x2e
[   45.452446]  [<ffffffff810bd65e>] do_readv_writev+0xa2/0x128
[   45.452454]  [<ffffffff810bdcf9>] ? fcheck_files+0x98/0xdc
[   45.452460]  [<ffffffff810bd722>] vfs_writev+0x3e/0x49
[   45.452465]  [<ffffffff810bd7e3>] sys_writev+0x45/0x69
[   45.452473]  [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b
[   45.452480] FIX skbuff_head_cache: Restoring
0xffff88013c92cea0-0xffff88013c92cea7=0xbb
[   45.452482]
[   45.452487] FIX skbuff_head_cache: Marking all objects used
