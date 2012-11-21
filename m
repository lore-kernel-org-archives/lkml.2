Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964862Ab2KUU4u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 15:56:50 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:33771 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798Ab2KUU4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 15:56:49 -0500
Date: Wed, 21 Nov 2012 13:56:45 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Peter H?we <PeterHuewe@gmx.de>
Cc: Peter.Huewe@infineon.com, key@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Subject: [PATCH] TPM: Switch to __packed instead of __attribute__((packed))
Message-ID: <20121121205645.GB15285@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be preferred these days.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/char/tpm/tpm.h |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

As discussed with Peter.

diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index c20fa8d..7d05ced 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -157,13 +157,13 @@ struct tpm_input_header {
 	__be16	tag;
 	__be32	length;
 	__be32	ordinal;
-}__attribute__((packed));
+} __packed;
 
 struct tpm_output_header {
 	__be16	tag;
 	__be32	length;
 	__be32	return_code;
-}__attribute__((packed));
+} __packed;
 
 struct	stclear_flags_t {
 	__be16	tag;
@@ -172,14 +172,14 @@ struct	stclear_flags_t {
 	u8	physicalPresence;
 	u8	physicalPresenceLock;
 	u8	bGlobalLock;
-}__attribute__((packed));
+} __packed;
 
 struct	tpm_version_t {
 	u8	Major;
 	u8	Minor;
 	u8	revMajor;
 	u8	revMinor;
-}__attribute__((packed));
+} __packed;
 
 struct	tpm_version_1_2_t {
 	__be16	tag;
@@ -187,20 +187,20 @@ struct	tpm_version_1_2_t {
 	u8	Minor;
 	u8	revMajor;
 	u8	revMinor;
-}__attribute__((packed));
+} __packed;
 
 struct	timeout_t {
 	__be32	a;
 	__be32	b;
 	__be32	c;
 	__be32	d;
-}__attribute__((packed));
+} __packed;
 
 struct duration_t {
 	__be32	tpm_short;
 	__be32	tpm_medium;
 	__be32	tpm_long;
-}__attribute__((packed));
+} __packed;
 
 struct permanent_flags_t {
 	__be16	tag;
@@ -224,7 +224,7 @@ struct permanent_flags_t {
 	u8	tpmEstablished;
 	u8	maintenanceDone;
 	u8	disableFullDALogicInfo;
-}__attribute__((packed));
+} __packed;
 
 typedef union {
 	struct	permanent_flags_t perm_flags;
@@ -242,12 +242,12 @@ struct	tpm_getcap_params_in {
 	__be32	cap;
 	__be32	subcap_size;
 	__be32	subcap;
-}__attribute__((packed));
+} __packed;
 
 struct	tpm_getcap_params_out {
 	__be32	cap_size;
 	cap_t	cap;
-}__attribute__((packed));
+} __packed;
 
 struct	tpm_readpubek_params_out {
 	u8	algorithm[4];
@@ -258,7 +258,7 @@ struct	tpm_readpubek_params_out {
 	__be32	keysize;
 	u8	modulus[256];
 	u8	checksum[20];
-}__attribute__((packed));
+} __packed;
 
 typedef union {
 	struct	tpm_input_header in;
@@ -268,16 +268,16 @@ typedef union {
 #define TPM_DIGEST_SIZE 20
 struct tpm_pcrread_out {
 	u8	pcr_result[TPM_DIGEST_SIZE];
-}__attribute__((packed));
+} __packed;
 
 struct tpm_pcrread_in {
 	__be32	pcr_idx;
-}__attribute__((packed));
+} __packed;
 
 struct tpm_pcrextend_in {
 	__be32	pcr_idx;
 	u8	hash[TPM_DIGEST_SIZE];
-}__attribute__((packed));
+} __packed;
 
 /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
  * bytes, but 128 is still a relatively large number of random bytes and
@@ -288,11 +288,11 @@ struct tpm_pcrextend_in {
 struct tpm_getrandom_out {
 	__be32 rng_data_len;
 	u8     rng_data[TPM_MAX_RNG_DATA];
-}__attribute__((packed));
+} __packed;
 
 struct tpm_getrandom_in {
 	__be32 num_bytes;
-}__attribute__((packed));
+} __packed;
 
 struct tpm_startup_in {
 	__be16	startup_type;
@@ -314,7 +314,7 @@ typedef union {
 struct tpm_cmd_t {
 	tpm_cmd_header	header;
 	tpm_cmd_params	params;
-}__attribute__((packed));
+} __packed;
 
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 
-- 
1.7.5.4

