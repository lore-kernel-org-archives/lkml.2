Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932687Ab1BWVHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:07:54 -0500
Received: from blv-smtpout-01.boeing.com ([130.76.32.69]:61613 "EHLO
	blv-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab1BWVHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:07:53 -0500
X-Greylist: delayed 741 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Feb 2011 16:07:53 EST
From: "Moffett, Kyle D" <Kyle.D.Moffett@boeing.com>
To: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Matthew McClintock <msm@freescale.com>,
        "Livingston, John A" <john.a.livingston@boeing.com>
Date: Wed, 23 Feb 2011 14:54:53 -0600
Subject: mpc85xx: kexec build broken by "powerpc/kexec: Remove
 ppc_md.machine_kexec"
Thread-Topic: mpc85xx: kexec build broken by "powerpc/kexec: Remove
 ppc_md.machine_kexec"
Thread-Index: AcvTm+3PhuC/z/OLQUqABeNiYNP2Lw==
Message-ID: <B87A2622-0006-4FC8-893A-41DBBF0CA170@boeing.com>
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

Hello everyone,

I just started trying to update some patches for our P2020-based unit to the latest Linus upstream, hoping to take advantage of the recent mpc85xx kexec() support.

Unfortunately I'm getting a compile error:

arch/powerpc/platforms/85xx/smp.c:241: error: 'struct machdep_calls' has no member named 'machine_kexec'

As far as I can tell, "machine_kexec" was removed in commit c9486878 (powerpc/kexec: Remove ppc_md.machine_kexec) on Jan 6th, 2011, which claims that it was not used.

Unfortunately it looks like it *is* used by the mpc85xx kexec() support (commit f933a41e), added on Jul 21, 2010.

Cheers,
Kyle Moffett

