Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781Ab1ERCOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:14:15 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33367 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab1ERCON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:14:13 -0400
Subject: Re: linux-next: build warning after merge of the scsi tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kiran Patil <kiran.patil@intel.com>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Yi Zou <yi.zou@intel.com>
In-Reply-To: <20110518114912.dfdf8835.sfr@canb.auug.org.au>
References: <20110518114912.dfdf8835.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 May 2011 19:06:02 -0700
Message-Id: <1305684362.2856.349.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-18 at 11:49 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (x86_64 allmodconfig)
> produced this warning:
> 
> drivers/target/tcm_fc/tfc_io.c: In function 'ft_queue_data_in':
> drivers/target/tcm_fc/tfc_io.c:209: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'size_t'
> 
> Introduced by commit 3699d92a4d7b ("[SCSI] tcm_fc: Adding FC_FC4 provider
> (tcm_fc) for FCoE target (TCM - target core) support").
> 

Hi Stephen,

It appears that this warning was fixed in LIO upstream a while back, but
did not make it into this morning scsi-misc merge.  Please apply.

Thanks!

--nab


>From b830de5068d0c3745e83393f81d87f745ef7a4f2 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Thu, 17 Feb 2011 21:56:16 +0000
Subject: [PATCH] tcm_fc: Fix conversion spec compile warning in ft_queue_data_in
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch fixes the following compile warning in ft_queue_data_in():

drivers/target/tcm_fc/tfc_io.c: In function ‘ft_queue_data_in’:
drivers/target/tcm_fc/tfc_io.c:209: warning: format ‘%x’ expects type ‘unsigned int’, but argument 5 has type ‘size_t’

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/tfc_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 4c3c0ef..3936bb1 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -206,7 +206,8 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
                                                "xid <0x%x>, remaining <0x%x>, "
                                                "lso_max <0x%x>\n",
                                                __func__, fp, ep->xid,
-                                               remaining, lport->lso_max);
+                                               (unsigned int)remaining,
+                                               lport->lso_max);
                }
        }
        return ft_queue_status(se_cmd);
-- 
1.7.5.1


