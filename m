Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab1DNHNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 03:13:46 -0400
Received: from nm11-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.244]:38604
	"HELO nm11-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757842Ab1DNHNn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:13:43 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 03:13:43 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 358981.39528.bm@omp1018.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LWIs1BzwsPEiQ6Dx6gnSI0tafjhOo4TRdD4WJorYZX1/gYuvPP3EpdjD7JVTzPyVRRyO2wH9jdXfYnjzkHuWQcY6zLSufc28uMXUmrskBPSMqFanijoAeKpnI8iFWWTTrDh8TxnOVeHeiJWeKrQXrPLSl0vh0hYXS1BnQs8YWck=;
Message-ID: <204286.97927.qm@web25602.mail.ukl.yahoo.com>
X-YMail-OSG: D.4Bm.oVM1nfC4tub42_7zueZbPFed.Z2bgPLPfSFNTocz9
 gn_4aZM6ZtYG3mmknHYTynzFkJ49YjmZzHAJ746CflHwLUzEGty2uTRZD2Mv
 mBlq4Ws0H7iJmomnGhZ26Dr1eNzkQDhC4H6BGXND_Y1IUo1ituaKvH2.Um7_
 xF.dWwKPqYMtzDUWX1PZAu8pZLkGfenacIEEax92T5uQ9xiTe5eRT8PHN14C
 E4riSYK991h4TN4fKDb6iPkSe4jIy7JgpFV_RYFEjLMuQH7T68xEJTwyXpvh
 B46wOMHs2.JmcCi93CewezKy7ck.G_RHORvOweWmDNWPu5gb_1r1feLhrqjw
 lElzgaSKQHIIFzdD4M4tHus4a1RyaOtA-
X-Mailer: YahooMailClassic/12.0.2 YahooMailWebService/0.8.109.295617
Date: Thu, 14 Apr 2011 08:06:54 +0100 (BST)
From: emre kara <emrekara2002@yahoo.co.uk>
Subject: fsl elbc driver causes corruption with bus monitor timeouts while simultaneously access on Nor / Nand mtd partitions
To: Scott Wood <scottwood@freescale.com>,
        Roy Zang <tie-fei.zang@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        David Woodhouse <David.Woodhouse@intel.com>,
        Lan Chunhe-B25806 <b25806@freescale.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>, felix@embedded-sol.com,
        bayraktarz@yahoo.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Scott, Roy.
Scott's "mtd: eLBC NAND: increase bus timeout to maximum" patch is excluded from kernel with Roy's "P4080/eLBC: Make Freescale elbc interrupt common to elbc devices" patch. I don't know the reason for it but this causes bus monitor timeouts and corrupts nand flash while using mainline kernel. As I know there is an errata related to this topic, I think "increasing bus timeout to maximum" is a must.
You can easly generate this situation with below commands:

Note: mtd4 is a Nor and mtd9 is a Nand partition.
[root@P2020RDB root]# mount /dev/mtdblock9 /mnt/src/
mount: you must specify the filesystem type
[root@P2020RDB root]# mount /dev/mtdblock9 /mnt/src/ -t jffs2
��JFFS2 notice: (1950) jffs2_build_xattr_subsystem: complete building xattr subsystem, 0 of xdatum (0 unchecked, 0 orphan) and 0 of xref (0 dead, 0 orphan) found.
[root@P2020RDB root]# dd if=/dev/mtd4 of=/mnt/src/uboot bs=1
fsl-lbc ffe05000.localbus: Local bus monitor time-out: LTESR 0x80000000
fsl-lbc ffe05000.localbus: command failed: fir 412e0000 fcr 0 status 80000000 mdr c0
Read of newly-erased block at 0x00430000 failed: -74. Putting on bad_list
fsl-lbc ffe05000.localbus: Local bus monitor time-out: LTESR 0x80000000
fsl-lbc ffe05000.localbus: command failed: fir 426db000 fcr 6070d000 status 80000000 mdr ff
Erase at 0x0042c000 failed immediately: errno -5
fsl-lbc ffe05000.localbus: Local bus monitor time-out: LTESR 0x80000000
Cfsl-lbc ffe05000.localbus: command failed: fir 412e0000 fcr 0 status 80000000 mdr c0
Read of newly-erased block at 0x00433000 failed: -74. Putting on bad_list
JFFS2: marking eraseblock at 00433000

Regards.

Emre

