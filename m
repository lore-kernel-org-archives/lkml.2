Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934685Ab0KQPHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:07:52 -0500
Received: from usindmx01.hds.com ([207.126.252.12]:56105 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094Ab0KQPHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:07:51 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        ext KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "marco.stornelli@gmail.com" <marco.stornelli@gmail.com>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        Aaron Durbin <adurbin@google.com>,
        "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>
CC: "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Wed, 17 Nov 2010 09:58:18 -0500
Subject: [PATCH 0/2] kmsg_dump: adding to reboot, halt, poweroff and
 emergency_restart path
Thread-Topic: [PATCH 0/2] kmsg_dump: adding to reboot, halt, poweroff and
 emergency_restart path
Thread-Index: AcuGZI2/m1RrdnFLRB6WCVKdkLnjOgAADLkQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C12D6E2F5@USINDEVS01.corp.hds.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAHF85UK004490

Hi,

This series aims to develop logging facility for enterprise use.

It is important to save kernel messages reliably on enterprise system 
because they are helpful for diagnosing system.

This series add kmsg_dump() to the paths loosing kernel messages.
The use case is the following.

[Use case of reboot/poweroff/halt/emergency_restart]

 My company has often experienced the followings in our support service.
 - Customer's system suddenly reboots.
 - Customers ask us to investigate the reason of the reboot.

 We recognize the fact itself because boot messages remain in /var/log/messages.
 However, we can't investigate the reason why the system rebooted,  because the last messages don't remain.
 And off course we can't explain the reason.
 
 
 We can solve above problem with this patch as follows.
 Case1: reboot with command 
   - We can see "Restarting system with command:" or ""Restarting system.".

 Case2: halt with command
   - We can see "System halted.".

 Case3: poweroff with command
   - We can see " Power down.".

 Case4: emergency_restart with sysrq.
   - We can see "Sysrq:" outputted in __handle_sysrq().

 Case5: emergency_restart with softdog.
   - We can see "Initiating system reboot" in watchdog_fire().

 So, we can distinguish the reason of reboot, poweroff, halt and emergency_restart.

 If customer executed reboot command, you may think the customer should know the fact.
 However, they often claim they don't execute the command when they rebooted system by mistake.

 No evidential message remain on current Linux kernel, so we can't show the proof to the customer.
 This patch improves this situation.


The first patch alters mtdoops and ramoops to perform their actions only for KMSG_DUMP_PANIC,
KMSG_DUMP_OOPS and KMSG_DUMP_KEXEC because they would like to log crashes only.

The latter patch adds kmsg_dump() to reboot, halt, poweroff and emergency_restart path.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
