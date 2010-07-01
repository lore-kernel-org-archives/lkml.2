Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315Ab0GALXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:23:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45265 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0GALXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:23:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KQ+THKhxz0em5PIUE95E5OILbVUoFDctXbJBvo9MENI4Rrvw3Gid9V2KPy1Dwe8FgY
         srI/VpUjKbaG22UZ4wEEZL7xEmyOjgLpl8t19O5HDE4nyaAZn91pJb2M89q5cnMeKe/p
         i89dFFqKfgA6JDeMSggNRnqBSltVULoU8Mlao=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Simon Horman <horms@verge.net.au>,
       Andrea Gelmini <andrea.gelmini@gelma.net>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/16] staging/otus: use ARRAY_SIZE
Date: Thu,  1 Jul 2010 15:23:00 +0400
Message-Id: <1277983381-29424-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/otus/hal/hpreg.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/otus/hal/hpreg.c b/drivers/staging/otus/hal/hpreg.c
index da3b774..17b84ca 100644
--- a/drivers/staging/otus/hal/hpreg.c
+++ b/drivers/staging/otus/hal/hpreg.c
@@ -29,9 +29,6 @@
 #include "hpreg.h"
 #include "hpusb.h"
 
-/* used throughout this file... */
-#define	N(a)	(sizeof(a) / sizeof(a[0]))
-
 #define HAL_MODE_11A_TURBO	HAL_MODE_108A
 #define HAL_MODE_11G_TURBO	HAL_MODE_108G
 
@@ -1557,7 +1554,8 @@ u8_t GetWmRD(u16_t regionCode, u16_t channelFlag, REG_DOMAIN *rd)
 	u64_t flags = NO_REQ;
 	REG_DMN_PAIR_MAPPING *regPair = NULL;
 
-	for (i = 0, found = 0; (i < N(regDomainPairs)) && (!found); i++) {
+	found = 0;
+	for (i = 0; (i < ARRAY_SIZE(regDomainPairs)) && (!found); i++) {
 		if (regDomainPairs[i].regDmnEnum == regionCode) {
 			regPair = &regDomainPairs[i];
 			found = 1;
@@ -1581,7 +1579,7 @@ u8_t GetWmRD(u16_t regionCode, u16_t channelFlag, REG_DOMAIN *rd)
 	 * unitary reg domain of the pair
 	 */
 
-	for (i = 0 ; i < N(regDomains) ; i++) {
+	for (i = 0 ; i < ARRAY_SIZE(regDomains) ; i++) {
 		if (regDomains[i].regDmnEnum == regDmn) {
 			if (rd != NULL) {
 					zfMemoryCopy((u8_t *)rd, (u8_t *)&regDomains[i],
@@ -1653,7 +1651,7 @@ void zfHpGetRegulationTable(zdev_t *dev, u16_t regionCode, u16_t c_lo, u16_t c_h
 
 	zmw_enter_critical_section(dev);
 
-	for (cm = modes; cm < &modes[N(modes)]; cm++) {
+	for (cm = modes; cm < &modes[ARRAY_SIZE(modes)]; cm++) {
 		u16_t c;
 		u64_t *channelBM = NULL;
 		REG_DOMAIN *rd = NULL;
@@ -1846,7 +1844,7 @@ void zfHpGetRegulationTablefromCountry(zdev_t *dev, u16_t CountryCode)
 
 	zmw_declare_for_critical_section();
 
-	for (i = 0; i < N(allCountries); i++) {
+	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
 		if (CountryCode == allCountries[i].countryCode) {
 			RegDomain = allCountries[i].regDmnEnum;
 
@@ -1881,7 +1879,7 @@ u8_t zfHpGetRegulationTablefromISO(zdev_t *dev, u8_t *countryInfo, u8_t length)
 		strLen = 3; */
 	}
 	/* zm_debug_msg_s("Desired iso name = ", isoName); */
-	for (i = 0; i < N(allCountries); i++) {
+	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
 		/* zm_debug_msg_s("Current iso name = ", allCountries[i].isoName); */
 		if (zfMemoryIsEqual((u8_t *)allCountries[i].isoName, (u8_t *)&countryInfo[2], length-1)) {
 			/* DbgPrint("Set current iso name = %s\n", allCountries[i].isoName); */
@@ -1937,7 +1935,7 @@ const char *zfHpGetisoNamefromregionCode(zdev_t *dev, u16_t regionCode)
 {
 	u16_t i;
 
-	for (i = 0; i < N(allCountries); i++) {
+	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
 		if (allCountries[i].regDmnEnum == regionCode)
 			return allCountries[i].isoName;
 	}
@@ -1953,7 +1951,7 @@ u16_t zfHpGetRegionCodeFromIsoName(zdev_t *dev, u8_t *countryIsoName)
 	/* if no matching item, return default */
 	regionCode = DEF_REGDMN;
 
-	for (i = 0; i < N(allCountries); i++) {
+	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
 		if (zfMemoryIsEqual((u8_t *)allCountries[i].isoName, countryIsoName, 2)) {
 			regionCode = allCountries[i].regDmnEnum;
 		break;
-- 
1.7.0.4

