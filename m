Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1CAPLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:11:10 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:48475 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab1CAPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:11:08 -0500
X-Greylist: delayed 472 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Mar 2011 10:11:08 EST
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 01 Mar 2011 17:03:08 +0200
From: denys@visp.net.lb
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: NMI received for unknown reason, 2.6.38-rc6
 =?UTF-8?Q?regression=3F?=
Message-ID: <950d04b27ce43565cdef24e4072d7e71@visp.net.lb>
User-Agent: VISP Webmail/0.5-beta
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I upgrade around 140 hosts (from 2.6.33 till 2.6.37), and got on many 
 of them error/warining, flooding kernel log. Here is short snapshot:

 [ 1882.057474] Uhhuh. NMI received for unknown reason 3c on CPU 0.
 [ 1882.057576] Do you have a strange power saving mode enabled?
 [ 1882.057672] Dazed and confused, but trying to continue
 [ 2421.419732] Uhhuh. NMI received for unknown reason 3c on CPU 0.
 [ 2421.419835] Do you have a strange power saving mode enabled?
 [ 2421.419930] Dazed and confused, but trying to continue
 [ 2636.016831] Uhhuh. NMI received for unknown reason 2c on CPU 1.
 [ 2636.016934] Do you have a strange power saving mode enabled?
 [ 2636.017003] Dazed and confused, but trying to continue

 Full dmesg from 2 machines:
 http://www.nuclearcat.com/dmesg1.txt
 http://www.nuclearcat.com/dmesg2.txt
 I can provide more, if required.

 It seems nmi_watchdog is enabled by default, and it is causing issue. I 
 am checking now with nmi_watchdog=0, but i need more time to confirm 
 that.
 Also i am experiencing some problem with ppp users(all of them is pppoe 
 servers), but i am not sure it is related to that, so maybe this NMI 
 warning is just cosmetic regression.

 All systems is x86, same kernel config.
 If you need more information - let me know.

