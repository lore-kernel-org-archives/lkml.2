Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0J0TxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:53:05 -0400
Received: from usindmx01.hds.com ([207.126.252.12]:51456 "EHLO
	usindmx01.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0J0TxD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:53:03 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "simon.kagstrom@netinsight.net" <simon.kagstrom@netinsight.net>,
        "David.Woodhouse@intel.com" <David.Woodhouse@intel.com>,
        "anders.grafstrom@netinsight.net" <anders.grafstrom@netinsight.net>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "jason.wessel@windriver.com" <jason.wessel@windriver.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eparis@redhat.com" <eparis@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Wed, 27 Oct 2010 15:44:45 -0400
Subject: RE: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
Thread-Topic: [RFC][Patch] Adding kmsg_dump() to
 reboot/halt/poweroff/emergency_restart path
Thread-Index: ActvFK6OI9dqc7pnS3O0xwo+/FcapgG+l+2A
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C1276CEC7@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C11B4B724@USINDEVS01.corp.hds.com>
 <20101018153350.18b68c50.akpm@linux-foundation.org>
In-Reply-To: <20101018153350.18b68c50.akpm@linux-foundation.org>
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

> What actual problem are we solving here?  Why is the current code
> inadequate?  It would help to demonstrate some use-case and to explain
> how the situation improved with this patch.

[Purpose]
 My purpose is developing highly reliable logging facility for enterprise use.

 I'm planning to add the following triggers of kmsg_dumper().
    - reboot/poweroff/halt/emergency_restart (this patch)
    - Machine check

 I'm also planning to add an feature outputting kernel messages to NVRAM, 
 because NVRAM is equipped with enterprise servers.
 We can realize highly reliable logging facility by outputting kernel messages to NVRAM.
 (NVRAM is commonly used on Mainframe and Commercial Unix as well.)

[Use case of reboot/poweroff/halt/emergency_restart]

 My company has often experienced the followings in our support service.
 - Customer's system suddenly reboots.
 - Customers ask us to investigate the reason of the reboot.

 We recognize the fact itself because boot messages remain in /var/log/messages.
 However, we can't investigate the reason why the system rebooted, 
 because the last messages don't remain.
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

Seiji
