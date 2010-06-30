Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab0F3GIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 02:08:19 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48132 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab0F3GIS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:08:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=eByRDVtqIhegYlsRc0ty2I+jkr2q/zjZtzNPcfpgK3iL2wc0YsmZ2mnbTd1ecp9fvy
         fpquyvYdtfq1gEt3YC6NGpgRx/BAUWgrwQqFNu1SLo6xrgvCDpsc09U12KNy0CeurqyF
         avwbx6zqjegRUSxfJSfDG7RY6p1oB7WTxS+/g=
MIME-Version: 1.0
Date: Wed, 30 Jun 2010 11:38:17 +0530
Message-ID: <AANLkTimFw9HQ6qvjSWIQ4vUFs4lU9j-jcjVKQIPKJ-pn@mail.gmail.com>
Subject: Interrupt Affinity in SMP
From: Hari LKML <hari.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We have HP DL380 Server with 48GB of DDR3/1333 MHz RAM, 4 1Gbps NIC
Ports, 1 External RAID Card, 1 Internal RAID Card and 2  Intel(R)
Xeon(R) CPU X5570  @ 2.93GHz used as an NFS storage server. Running
Ubuntu 9.10 2.6.31-14-server.
(The Storage is used as an NFS storage for more than 300VMs running
using Citrix XenServer)

For More info on the Hard ware configuration
http://h18000.www1.hp.com/products/quickspecs/12028_div/12028_div.html

With HTT enabled in BIOS i can see 16 CPU(0-15) as per cat /proc/cpuinfo.

The problem is all the interrupts are handled by CPU0, as per
/proc/interrupts including the timer interrupts.
And the value of /proc/irq default_smp_affinity is ffff.
Also for all the interrupts the smp_affinity is ffff.

What i believe is with these setting all the interrupts should be
handled by the First 8 CPUs in a Round robin Fashion.
Or in our case at worse by the first 4 cores (since HTT is enabled -
*not clear with this concept though some once please put some light
over here also for better understanding :-)* ).

Also i tried to edit the smp_affinity of an interrupt to a value 0004
to test that if the interrupt is handled by some other core. But i was
unable to edit this value in a running system i got the access denied
error so i can't do this.

Please help me in distributing the interrupts among the other cores of
my system which might increase some performance of my system.

let me know if you need some log of the system or some other info
about the system.

Hari
