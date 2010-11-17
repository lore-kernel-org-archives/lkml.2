Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935065Ab0KQQp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:45:57 -0500
Received: from nm16-vm0.bullet.mail.ukl.yahoo.com ([217.146.183.254]:34716
	"HELO nm16-vm0.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934973Ab0KQQp4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:45:56 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 598220.14454.bm@omp1026.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.no;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Cz/Cy8bCs/KyCPMRRDtQRMb3NbUg3aEvxTTf/mQpVTWKN7odQHGHPRNFpna9F528CVwiFuCVZ7cjUALLepErPkW2JFxc6qs/IJa72QQcWc7Ae9HFKGBG2dA8VyhesOW1m/+eB/6oOEcN958vmMR0IQPzDt/gTdD2s4IrAD5bHVs=;
Message-ID: <452269.51735.qm@web27103.mail.ukl.yahoo.com>
X-YMail-OSG: SFwjqnIVM1lkRclzThnzwhTacMrfAwqZxFPu8w.6YSMjD.E
 TgiZp4pikDxeAj2MXnYWNOL0gchXQ7IczicVrnS99t.8G24awPNJCBXo_Deq
 yAtL7l6lzy9HC5t6w7zIvmSkD7sggcHjtOJqLdQM.nhRbKvJ9aXC0OqCvuQp
 KiNmIhaZ7z9nt8iIeLwhAkTmp5Myh9mRSpOp4j4dGolA9Ic0Gz34cwi8Caf4
 13V2DfxNWsms70mt.N5YWpPj94POxqYrAyYKOMB9qKgs60Vj5XPrsXtAuOPJ
 bf8ETrvxka1ZjQQZ61WLteQQwXKdqyQrT5hQmOw--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.285259
Date: Wed, 17 Nov 2010 16:45:54 +0000 (GMT)
From: Kjell Rune Skaaraas <kjella79@yahoo.no>
Subject: Regression: DisplayPort stops working between 2.6.37-rc1 and rc2
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't find a smaller list for graphics, so here goes. Between 2.6.37-rc1 and 2.6.37-rc2 my DisplayPort monitor has stopped working. I can reboot between the kernel versions and reproduce this, so it's not due to any other package upgrade. If I go into the system settings I now only have three ports listed, DisplayPort-0 is missing.

This is on a Radeon HD5850 using the open source radeon drivers. Kernels are Ubuntu kernel PPA mainline builds, all the X11 packages follow the xorg-edgers PPA and are close to git. Going from the rc2 change log these would be suspects:

Alex Deucher (5):
      drm/radeon/kms/evergreen: add missing pm.vblank_sync update in vbl handler
      drm/radeon/kms: make the connector code less verbose
      drm/radeon/kms: don't disable shared encoders on pre-DCE3 display blocks
      drm/radeon/kms: add support for clock/data path routers
      drm/radeon/kms: fix thermal sensor reporting on rv6xx
Michel Dänzer (1):
      drm/radeon/kms: Fix retrying ttm_bo_init() after it failed once.
Tyson Whitehead (1):
      drm/radeon/kms: fix bugs in ddc and cd path router code

I'm not all that great with git so haven't worked out how to pin down what commit is actually causing it.

Regards,
Kjell Rune


