Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516Ab2J2VlL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:41:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:48376 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761399Ab2J2VlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:41:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 02/54] drm/radeon: add error output if VM CS fails on cayman
Date: Mon, 29 Oct 2012 14:40:03 -0700
Message-Id: <20121029213803.010236471@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213802.697479610@linuxfoundation.org>
References: <20121029213802.697479610@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit c71721324c612f7f040657ce9917d87f530f9784 upstream.

So we know why the CS was rejected.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_cs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -2775,6 +2775,7 @@ static bool evergreen_vm_reg_valid(u32 r
 	case CAYMAN_SQ_EX_ALLOC_TABLE_SLOTS:
 		return true;
 	default:
+		DRM_ERROR("Invalid register 0x%x in CS\n", reg);
 		return false;
 	}
 }


