Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1CJIV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:21:27 -0500
Received: from nm9-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.192]:20572 "HELO
	nm9-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751927Ab1CJIVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:21:24 -0500
X-Yahoo-Newman-Id: 521529.73642.bm@omp1011.mail.ac4.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: uqWv6xcVM1kFiDtm2ok0QdqD9wzUJhAdGMdY7vAfti1CDGw
 NZW4AXLcQBi8Ye752FyL1ia3YYkJPmXwglr88ZRfYB0n6PxHYmpAf8MzO3xB
 iFUlpfLDTDMpgRJa2pZoD62z8eIPowRomiKuiuFzssWigxKvLns3Syl34NKE
 rIxmDNCHWAc1O5h9Dtu4nSiGkM2FwiEsz1VHBUbYLDr8ykZJJ30G1_aa4YOK
 51xr8ps.zd0d3qaeWw1XbmNrGYamFzDENwGQ4Kj_TjWLKujCkj9tZersSNLa
 Kpkz_D.36adln4SEWRqDGH6wbNrAplO86K5OPR55oV9dpSbR5Wf0RiWpymhu
 6ICOuLg8.8nh6v7fImRS_3dIITV.ffoj.iKQwrbvT
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>,
        Randy Dunlap <rdunlap@xenotime.net>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/2] Add struct crypto_alg->cra_check_optimized for crc32c_intel
Date: Thu, 10 Mar 2011 00:21:10 -0800
Message-Id: <1299745272-25477-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Herbert and Co,

This series adds a struct crypto_alg->cra_check_optimized() that can be optionally
used by crc32c.ko (and other algorithms) in order to make a request_module() call
to load architecture dependent offload code for a libcrypto base algorithm.

This patch is a result of feedback during review for the iscsi_target_mod fabric
module here:

Re: [RFC 12/12] iscsi-target: Add Makefile/Kconfig and update TCM
http://marc.info/?l=linux-scsi&m=129974455726437&w=2

Please review and comment,

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  crypto: Add struct crypto_alg->cra_check_optimized
  crypto/crc32c: Add crc32c_cra_check_optimized for crc32c_intel

 crypto/api.c           |    6 +++++-
 crypto/crc32c.c        |   23 +++++++++++++++++++++++
 include/linux/crypto.h |    1 +
 3 files changed, 29 insertions(+), 1 deletions(-)

