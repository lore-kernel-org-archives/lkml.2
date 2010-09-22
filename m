Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0IVDCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 23:02:30 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:57243 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0IVDC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 23:02:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>,
        Chris Ball <cjb@laptop.org>, Hein_Tibosch <hein_tibosch@yahoo.es>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: mmotm 2010-09-15 - BUG in mmc driver calling led_trigger_event()
In-Reply-To: Your message of "Wed, 15 Sep 2010 16:21:43 PDT."
             <201009152352.o8FNqXGr022752@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201009152352.o8FNqXGr022752@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1285124506_4916P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 21 Sep 2010 23:01:47 -0400
Message-ID: <8581.1285124507@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4C99719C.00B0,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1285124506_4916P
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Sep 2010 16:21:43 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-09-15-16-21 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Dell Latitude E6500. lspci -v says:

03:01.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21) (prog-if 01)
        Subsystem: Dell Device 024f
        Flags: bus master, medium devsel, latency 64, IRQ 18
        Memory at f1bff600 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
        Kernel driver in use: sdhci-pci

Not consistently repeatable - I had 3 clean boots of this kernel, hit this the 4th time.

[    2.928661] Freeing unused kernel memory: 892k freed
[    2.934051] BUG: sleeping function called from invalid context at kernel/mutex.c:278
[    2.934440] in_atomic(): 1, irqs_disabled(): 0, pid: 11, name: kworker/0:1
[    2.934777] 3 locks held by kworker/0:1/11:
[    2.934780]  #0:  (((dev_name(&(mmc)->class_dev)))){+.+...}, at: [<ffffffff81052388>] process_one_work+0x1b5/0x49d
[    2.934796]  #1:  ((&host->finish_work)){+.+...}, at: [<ffffffff81052388>] process_one_work+0x1b5/0x49d
[    2.934806]  #2:  (&trigger->leddev_list_lock){.+.+..}, at: [<ffffffff813d464e>] led_trigger_event+0x22/0x75
[    2.934821] Pid: 11, comm: kworker/0:1 Not tainted 2.6.36-rc4-mmotm0915 #2
[    2.934825] Call Trace:
[    2.934833]  [<ffffffff8102e456>] __might_sleep+0x124/0x129
[    2.934840]  [<ffffffff8156559e>] mutex_lock_nested+0x20/0x39
[    2.934846]  [<ffffffff813d1412>] sdhci_led_control+0x24/0x52
[    2.934852]  [<ffffffff813d464e>] ? led_trigger_event+0x22/0x75
[    2.934858]  [<ffffffff813d4682>] led_trigger_event+0x56/0x75
[    2.934865]  [<ffffffff813c74c8>] mmc_request_done+0x5c/0x7a
[    2.934871]  [<ffffffff813d1aba>] sdhci_finish_work+0xe6/0xef
[    2.934877]  [<ffffffff81052472>] process_one_work+0x29f/0x49d
[    2.934882]  [<ffffffff81052388>] ? process_one_work+0x1b5/0x49d
[    2.934888]  [<ffffffff813d19d4>] ? sdhci_finish_work+0x0/0xef
[    2.934895]  [<ffffffff81052d10>] worker_thread+0x17e/0x251
[    2.934901]  [<ffffffff81052b92>] ? worker_thread+0x0/0x251
[    2.934908]  [<ffffffff81056882>] kthread+0x7d/0x85
[    2.934915]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
[    2.934922]  [<ffffffff815676c0>] ? restore_args+0x0/0x30
[    2.934928]  [<ffffffff81056805>] ? kthread+0x0/0x85
[    2.934934]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
[    2.941048] mmc0: mmc_rescan: trying to init card at 200000 Hz

Only config diff between the first 3 boots and this one:

 #
 CONFIG_BINFMT_ELF=y
 CONFIG_COMPAT_BINFMT_ELF=y
-CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 # CONFIG_HAVE_AOUT is not set
 CONFIG_BINFMT_MISC=y
 CONFIG_IA32_EMULATION=y

which shouldn't matter.

Anything obvious to you guys? Race condition of some sort, or somebody else
leaving a dangling in_atomic() status for us to get ambushed by? Maybe Hein's
patches to retry at multiple freqs are causing one of the retries to happen at a
bad time? I'm mystified.


--==_Exmh_1285124506_4916P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMmXGacC3lWbTT17ARAs4KAJ9Q2rUE2Y72X0NSjgFjswTyO5JU1gCfaS8u
3v1oy8XxvKHOAguPo5iuN9U=
=tFPQ
-----END PGP SIGNATURE-----

--==_Exmh_1285124506_4916P--

