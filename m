Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab0CQPML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:12:11 -0400
Received: from mail-bw0-f212.google.com ([209.85.218.212]:53325 "EHLO
	mail-bw0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0CQPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:12:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=Rs/dyKMfgBf9RBRkaWTjRdEJeKi+6fPqUp5iM1Jmf6g5tq02zbgRE0SOC+l/m0niEq
         szLeijnXYQG8bdCTJPe5TbPnfxKvlI/dnTVYVV5NjhTa0Ft8/g7slUdjfBIUXFUEpNJH
         q78l2CaCcc6ikv3lTjDy+jyTkbgrFeOdoO0MQ=
Date: Wed, 17 Mar 2010 18:11:56 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] ivtv: sizeof() => ARRAY_SIZE()
Message-ID: <20100317151156.GG5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a smatch warning:
drivers/media/video/ivtv/ivtv-vbi.c +138 ivtv_write_vbi(43) 
	error: buffer overflow 'vi->cc_payload' 256 <= 1023

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/ivtv/ivtv-vbi.c b/drivers/media/video/ivtv/ivtv-vbi.c
index f420d31..d73af45 100644
--- a/drivers/media/video/ivtv/ivtv-vbi.c
+++ b/drivers/media/video/ivtv/ivtv-vbi.c
@@ -134,7 +134,7 @@ void ivtv_write_vbi(struct ivtv *itv, const struct v4l2_sliced_vbi_data *sliced,
 			}
 		}
 	}
-	if (found_cc && vi->cc_payload_idx < sizeof(vi->cc_payload)) {
+	if (found_cc && vi->cc_payload_idx < ARRAY_SIZE(vi->cc_payload)) {
 		vi->cc_payload[vi->cc_payload_idx++] = cc;
 		set_bit(IVTV_F_I_UPDATE_CC, &itv->i_flags);
 	}
