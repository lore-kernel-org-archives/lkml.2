Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2EGNQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 09:16:35 -0400
Received: from pc12772.Mathematik.Uni-Marburg.DE ([137.248.123.123]:48439 "EHLO
	pc12772.Mathematik.Uni-Marburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab2EGNQe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 09:16:34 -0400
X-Greylist: delayed 765 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2012 09:16:33 EDT
From: Christian Strack <strack@Mathematik.Uni-Marburg.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Debug Exception Handling in Linux
Date: Mon, 7 May 2012 15:03:46 +0200
Message-Id: <4E9AE794-8227-4FA5-910A-5F612926A5AB@mathematik.uni-marburg.de>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1257)
X-Mailer: Apple Mail (2.1257)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (pc12772.Mathematik.Uni-Marburg.de [137.248.123.123]); Mon, 07 May 2012 15:03:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to single-step processes in  a HVM Linux guest using Xen on Intel VT. Especially i've changed the Ether patch for Xen to be able to handle Linux guests. My Problem is that every single step the RIP stored in the VMCS points to kernel instructions (>0xC0000000) and thus only kernel instructions are stepped. To achieve single-stepping, both the exception bitmap and the rflags are masked with the trap flag, debug register 6's 14th bit is set (single-stepping) and the exception is send to the guest using 

vmx_inject_hw_exception(v, TRAP_debug, VMX_DELIVER_NO_ERROR_CODE);

Has anybody a clue why the RIP points to kernel instructions or where the userland RIP is stored at this time? To avoid misunderstandings, i'm not searching for Xen specific answers. It would be very helpful if you could enlight me how the linux kernel handles debug exceptions or where the userland RIP is stored.

Kind regards
Christian

PS: Please add my address to CC

---
Ether patch: http://ether.gtisc.gatech.edu/source.html