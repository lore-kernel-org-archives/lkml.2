Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2FFO35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:29:57 -0400
Received: from nm11-vm2.bullet.mail.ne1.yahoo.com ([98.138.90.159]:48410 "HELO
	nm11-vm2.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753877Ab2FFO3z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:29:55 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jun 2012 10:29:55 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 658734.72984.bm@omp1023.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Pr5ZJWwTv2xee7AOnOXbQFVm1YQN2fR4fiZVf4rnGZyyCkw9jfXY6Tubt6cn8WmhZcd/eYqjKjwUpliHijvfGU2e/hFcLm3L6XOTmp2bjcojewVUK7FlfmSs4FHbxNMSnx85BBLlGcUVN5JeLQ77+yVaUqqfBgtr7joEQc8RCNg=;
X-YMail-OSG: GSZQTMEVM1lJ.8GuvQBHZHKxCkhwKPch3Cggr5s6F8q9xir
 rpQ7agEQEpiqYnvWMAC_7.u39np61LjEP0wL9MKgzWwFTAYP1m7QlzFt2nQR
 A2ZjTWkNMD9J7B2.UymCkH4pLfinA1SVdJgTWqEdbE5ppgmXd8h2TRztv9JL
 tleYh_O2K2KNNn.7Nm8159heb_V3zUoBZqscfUP8Q4P_fdTMhuRUU4vC2imB
 wc3.llKL2v5tv9MmX3pqCwxIuTJrMTyrPA6ZArb1QPYeGWFSx5Ka90Ah_ff1
 WnjBdreneo5JZT4V2WUeVsVKscHDvHo2xK4YvS6S8sMQ2KHJEnk45BOmjjD1
 meYtui_gHGreM9Ae.XeUI0Qb2sP.kwnAI0bjPF1pwSgmTm7d1BT.Q0uuOleU
 D9rBy
X-Mailer: YahooMailWebService/0.8.118.349524
Message-ID: <1338992680.29947.YahooMailNeo@web122006.mail.ne1.yahoo.com>
Date: Wed, 6 Jun 2012 07:24:40 -0700 (PDT)
From: Bob Sullivan <bobsullivan60@yahoo.com>
Reply-To: Bob Sullivan <bobsullivan60@yahoo.com>
Subject: file corruption in loop device in 3.4.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a EXT3 filesystem contained in a file
(a disk image mapped to a file using loop device).
Using diff, observed random differences between
files on the image and a backup copies of those files.
This problem is reproducible,
tried booting several times with 3.3.8 and 3.4.0.
No problems on 3.3.8.
But every time on 3.4.0, randomly a few files showed corruption.
Some files that were corrupt become ok again after rebooting/remounting.
About 5% of the file contents was garbage, rest was correct, the file size was correct.

Seems to be a memory problem in 3.4.0?
chkdsk never showed any problem (in the disk image file).

Using Debian 6.  Ran memtest86+, chkdsk, badblocks -- no errors.
Disk image was created mkfs.ext3 with the smallest inode/block size.
