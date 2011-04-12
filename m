Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1DLOiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:09 -0400
Received: from kroah.org ([198.145.64.141]:57580 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033Ab1DLOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:07 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:52 2011
Message-Id: <20110412143552.766951992@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [045/105] drm/radeon/kms: add some sanity checks to obj info record parsingi (v2)
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: John Lindgren <john.lindgren@tds.net>

commit 97ea530f6fac1f9632b0c4792a2a56411454adbe upstream.

Fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=35502

agd5f: also add sanity check to connector records.

v2: fix one more case.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -675,7 +675,8 @@ bool radeon_get_atom_connector_info_from
 							ATOM_ENCODER_CAP_RECORD *cap_record;
 							u16 caps = 0;
 
-							while (record->ucRecordType > 0 &&
+							while (record->ucRecordSize > 0 &&
+							       record->ucRecordType > 0 &&
 							       record->ucRecordType <= ATOM_MAX_OBJECT_RECORD_NUMBER) {
 								switch (record->ucRecordType) {
 								case ATOM_ENCODER_CAP_RECORD_TYPE:
@@ -720,7 +721,8 @@ bool radeon_get_atom_connector_info_from
 									break;
 							}
 
-							while (record->ucRecordType > 0 &&
+							while (record->ucRecordSize > 0 &&
+							       record->ucRecordType > 0 &&
 							       record->ucRecordType <= ATOM_MAX_OBJECT_RECORD_NUMBER) {
 								switch (record->ucRecordType) {
 								case ATOM_I2C_RECORD_TYPE:
@@ -782,10 +784,9 @@ bool radeon_get_atom_connector_info_from
 						ATOM_HPD_INT_RECORD *hpd_record;
 						ATOM_I2C_ID_CONFIG_ACCESS *i2c_config;
 
-						while (record->ucRecordType > 0
-						       && record->
-						       ucRecordType <=
-						       ATOM_MAX_OBJECT_RECORD_NUMBER) {
+						while (record->ucRecordSize > 0 &&
+						       record->ucRecordType > 0 &&
+						       record->ucRecordType <= ATOM_MAX_OBJECT_RECORD_NUMBER) {
 							switch (record->ucRecordType) {
 							case ATOM_I2C_RECORD_TYPE:
 								i2c_record =


