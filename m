Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0IOWls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 18:41:48 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.106]:34135 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753940Ab0IOWlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 18:41:47 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: VB_DJHEVM1kdZNxByBAt7yb2aBvHIqQwC2F16Vn.PQkt0au
 V0ndFog63bdFddY4ElLFg3HZs2oOTMVNkOXUkbpr2AClXx0bHwynSyIF3WXO
 h2L00feNocmZgDUfPv9nVnGdPsagb6utf25jJzHfFjzVelLkcaH7.YnoeEC6
 cPyrtHhXx1Bas28X86kVZF_Hruia_OzhmpojejnwWnbt6tc6kGjKGQ4uJfKk
 wcQdXZzHN848dYKWYg9VAwpTyYCWH7ZSWVaeirT27D_Ijo.ozc0cUR7t7isn
 53UXwbLpleN15TiSYKF43CRHwTPfPoUrk45Gts9sZJ4WhBIXlIL35s2vkUII
 VprPzQL7JPNrC2rWLtw--
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Joe Eykholt <jeykholt@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH v2 0/2] tcm/tcm_loop: Add BIDI-COMMAND support
Date: Wed, 15 Sep 2010 15:41:43 -0700
Message-Id: <1284590503-6210-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Boaz and Co,

This is the rebased TCM Core + TCM_Loop module BIDI-COMMAND v2 patch series to
address Boaz's comments about the proper usage of DMA_BIDIRECTIONAL within
TCM Core and TCM_Loop and his other points.  I have already pushed the follow up
patches into lio-core-2.6.git/lio-4.0, and this is a follow up series for Boaz
to add comments w/o the original incorrect DMA_BIDIRECTIONAL usage in the v1 code.

So far this has been tested  with the same custom XDWRITE_READ_10 BSG userspace
code as the v1 patch and things are functioning as expected so far.  I will also
be testing with an BIDI capable sg_raw patch from Doug Gilbert. (Thanks Doug!)

Many thank go to Boaz for sharing his knowledge of BIDI for adding proper support
into TCM Core and TCM_Loop code!

Best,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  tcm: Add support for BIDI-COMMANDS and XDWRITE_READ_10 emulation
  tcm_loop: Add BIDI-COMMAND CDB support

 drivers/target/target_core_pr.c                |    3 +-
 drivers/target/target_core_transport.c         |  278 ++++++++++++++++++++----
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c |   47 +++-
 include/target/target_core_base.h              |   10 +-
 include/target/target_core_transport.h         |   10 +-
 5 files changed, 288 insertions(+), 60 deletions(-)

