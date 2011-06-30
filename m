Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab1F3Vla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 17:41:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17277 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1F3Vl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 17:41:28 -0400
MIME-Version: 1.0
Message-ID: <8bc97678-257f-4b68-96c2-4cb43fa9579c@default>
Date: Thu, 30 Jun 2011 14:41:06 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [GIT PULL] xen: tmem: self-ballooning and frontswap-selfshriking
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E0CED86.0013:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad --

Please pull the following branch into your Xen for-linus tree
for the upcoming 3.1 window.

git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git #xen-tmem-selfballoon-v3

The branch is based off of 3.0-rc1.

This single commit introduces two in-kernel drivers for Xen
transcendent memory ("tmem") that complement cleancache and
frontswap.  Both use control theory to dynamically adjust and
optimize memory utilization.  Much more detail is in the
header comment of the file.

Diffstat:
 drivers/xen/Kconfig                      |   12 
 drivers/xen/Makefile                     |    1 
 drivers/xen/xen-balloon.c                |    2 
 drivers/xen/xen-selfballoon.c            |  429 +++++++++++++++++++++
 include/xen/balloon.h                    |   10 
 include/xen/tmem.h                       |    5 
 6 files changed, 459 insertions(+)

Dan Magenheimer (1):
      xen: tmem: self-ballooning and frontswap self-shrinking

Note that this patch has a slight build dependency on last week's:

afec6e04922d0c8c7e244be2e544bac5e7e36294 xen: prepare tmem shim to handle frontswap

in your devel/next-3.0 branch (because tmem_enabled is EXPORT_SYM'ed
in that commit and extern'ed in a file in this commit).  I don't
think this is a problem as you've already pushed that commit
to linux-next, but am noting the dependency in case some kind
of commit reordering were to occur.

Thanks,
Dan
