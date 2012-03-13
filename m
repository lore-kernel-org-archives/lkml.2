Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260Ab2CMEhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:37:38 -0400
Received: from mta111.odn.ne.jp ([143.90.14.106]:60111 "EHLO cmta111.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2CMEhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:37:35 -0400
X-Greylist: delayed 518 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Mar 2012 00:37:35 EDT
Message-ID: <4F5ECD06.3000608@yahoo.co.jp>
Date: Tue, 13 Mar 2012 13:28:54 +0900
From: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier Sil3726
References: <201203122030.q2CKUjb2022067@bzweb02.app.bz.hst.phx2.redhat.com>
In-Reply-To: <201203122030.q2CKUjb2022067@bzweb02.app.bz.hst.phx2.redhat.com>
X-Enigmail-Version: 1.3.5
X-Forwarded-Message-Id: <201203122030.q2CKUjb2022067@bzweb02.app.bz.hst.phx2.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060004000107040303010208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060004000107040303010208
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hi!

I'm in trouble on a PC that has 6 eSATA port multiplier.

>From kernel 3.2.x, kernel fails to boot when many HDDs are connected to
many eSATA port multiplier with Sil3726.

Kernel is repeating eSATA bus reset while booting and spend long time,
and result into fail to boot with timeout. It causes that some HDDs
cannot be seen from kernel on a PC that has 6 Sil3726 port multiplier.
dmesg contains many reset messages while booting like this:
   :
> [   48.060454] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [   48.061150] ata6.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [   48.063158] ata6.00: hard resetting link
> [   48.401020] ata6.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
> [   48.401080] ata6.01: hard resetting link
> [   48.825741] ata6.01: softreset failed (SRST command error)
> [   48.935499] ata6.01: failed to read SCR 0 (Emask=0x1)
> [   48.935505] ata6.01: reset failed (errno=-85), retrying in 10 secs
   :
> [  294.950152] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  294.950453] ata9.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> [  294.953382] ata9.00: hard resetting link
> [  304.937981] ata9.00: softreset failed (timeout)
> [  307.931302] ata9.15: qc timeout (cmd 0xe4)
> [  307.931318] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  307.931322] ata9.00: reset failed, giving up
> [  307.931327] ata9.15: hard resetting link
> [  310.058635] ata9.15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  310.059016] ata9.00: hard resetting link
> [  320.044490] ata9.00: softreset failed (timeout)
> [  323.037851] ata9.15: qc timeout (cmd 0xe4)
> [  323.037868] ata9.00: failed to read SCR 0 (Emask=0x5)
> [  323.037872] ata9.00: reset failed, giving up
   :
> [  556.513676] systemd[1]: Job dev-disk-by\x2dlabel-WORK.device/start timed out.
> [  556.513693] systemd[1]: Job fedora-autorelabel-mark.service/start failed with result 'dependency'.
> [  556.513816] systemd[1]: Job fedora-autorelabel.service/start failed with result 'dependency'.
> [  556.513833] systemd[1]: Job local-fs.target/start failed with result 'dependency'.
> [  556.513846] systemd[1]: Triggering OnFailure= dependencies of local-fs.target.
> [  556.515352] systemd[1]: Job mnt-work.mount/start failed with result 'dependency'.
> [  556.515368] systemd[1]: Job dev-disk-by\x2dlabel-WORK.device/start failed with result 'timeout'.
> [  556.851000] systemd[1]: Startup finished in 2s 212ms 906us (kernel) + 7min 44s 688ms 483us (initrd) + 1min 30s 977ms 147us (userspace) = 9min 17s 878ms 536us.

When only one sentence in drivers/ata/libata-pmp.c only for Sil3726 back
to that in kernel 3.1.x, this problem is not seen. I attached the patch
file.

This patch solves the problem on my PC but I can't understand ata
subsystem. So I'm afraid of side effect.

Can you consider this patch?

Best Regards,
ANEZAKI, Akira

-------- Original Message --------
Subject: [Bug 787468] boot fails by timeout while activating RAIDs with
many HDDs
Date: Mon, 12 Mar 2012 16:30:45 -0400
From: bugzilla@redhat.com
To: fireblade1230@yahoo.co.jp

Please do not reply directly to this email. All additional
comments should be made in the comments box of this bug.


https://bugzilla.redhat.com/show_bug.cgi?id=787468

--- Comment #20 from Dave Jones <davej@redhat.com> 2012-03-12 16:30:43
EDT ---
can you post this patch upstream to linux-kernel@vger.kernel.org ?
if it is acceptable there, we will add it to the Fedora kernel.

-- 
Configure bugmail: https://bugzilla.redhat.com/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are on the CC list for the bug.
You reported the bug.

--------------060004000107040303010208
Content-Type: text/x-patch;
 name="libata-pmp.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="libata-pmp.c.patch"

--- a/drivers/ata/libata-pmp.c	2012-03-12 20:43:00.625871123 +0900
+++ b/drivers/ata/libata-pmp.c	2012-03-12 20:43:19.845080223 +0900
@@ -391,7 +391,8 @@ static void sata_pmp_quirks(struct ata_p
 
 			/* Class code report is unreliable. */
 			if (link->pmp < 5)
-				link->flags |= ATA_LFLAG_ASSUME_ATA;
+				link->flags |= ATA_LFLAG_NO_SRST |
+					       ATA_LFLAG_ASSUME_ATA;
 
 			/* port 5 is for SEMB device and it doesn't like SRST */
 			if (link->pmp == 5)

--------------060004000107040303010208--
