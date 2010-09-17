Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0IQFep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:34:45 -0400
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:26894 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750860Ab0IQFem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:34:42 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: BlVPh6wVM1kggkRiSiY3eyREMs6sLVHxolDkIZ6gelc5qEL
 NriTka5eUy4xSMyjUTt4XwPVHEdiXcaG41O_tvmJADHchX_nztwkDbyxo5ML
 wBfrDETk183imiVc2Cce2.VgB4ipJaB0Bi3rCSTAtVC9L8yBa_GSLnYK9W2b
 zrVT9iRg7Q5sOeAyHYm88A1zZG33wBySrG1SQfQ1KG5QF04yE8C2gKNYDfgl
 fXY5jtNwFLJZN.GJZkbwamX.O4.L1zI3ziQc78UcB8XwtLwF4jP3SCdjQFyw
 gP4ZskgMXAq8qH1HOoPjn0xR0jIzAeJLvyNWVngh_H3gCiZTLuA--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Hannes Reinecke <hare@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Joe Eykholt <jeykholt@cisco.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: Add native 32-byte CDB support
Date: Thu, 16 Sep 2010 22:34:34 -0700
Message-Id: <1284701674-18323-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings jejb, mkp and Co,

This patch series adds support for native 32-byte CDB processing into TCM Core,
TCM subsystem plugins, and TCM_Loop virtual SCSI LLD.

The first patch adds the new TCM_MAX_COMMAND_SIZE=32 defintion and adds the necessary
LBA + transfer length extraction and generation methods for 32-byte CDBs following
SBC-4.  This includes converting FILEIO, IBLOCK, PSCSI, RAMDISK and STGT subsystem
plugins to use the new TCM_MAX_COMMAND_SIZE value for their own per struct se_task
context descriptor internal inline CDB size defines.

The second patch adds proper VARIABLE_LENGTH_CMD support together with XDWRITE_READ_32
emulation following the recent patch adding support for XDWRITE_READ_10.

And the third and final patch updates the TCM_Loop fabric module to signal the
Linux/SCSI midlayer that we are now capable of processing up to 32-byte CDBs.

Also, I ended up adding support for XDWRITE_READ_32 into Tomo's sgv4-utils.git in
order to test this series.  Please have look and let me know what you think Tomo!

http://linux-iscsi.org/builds/user/nab/0001-sgv4_xdwriteread-Add-support-for-XDWRITEREAD_32.patch

Many thanks to jejb and mkp for answering my questions about > 16 byte CDB support!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Add native 32-byte CDB support
  tcm: Add VARIABLE_LENGTH_CMD support w/ XDWRITE_READ_32 emulation
  tcm_loop: Enable 32-byte CDB support in virtual SCSI LLD

 drivers/target/target_core_file.h       |    2 +-
 drivers/target/target_core_iblock.h     |    2 +-
 drivers/target/target_core_pscsi.c      |    2 +-
 drivers/target/target_core_pscsi.h      |    2 +-
 drivers/target/target_core_rd.h         |    2 +-
 drivers/target/target_core_scdb.c       |   38 ++++++++++++
 drivers/target/target_core_scdb.h       |    2 +
 drivers/target/target_core_stgt.h       |    2 +-
 drivers/target/target_core_transport.c  |   94 +++++++++++++++++++++++++++----
 drivers/target/tcm_loop/tcm_loop_core.h |    2 +-
 include/target/target_core_base.h       |   13 ++++
 11 files changed, 142 insertions(+), 19 deletions(-)

