Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab0DIWM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:12:56 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:52170 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751321Ab0DIWMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:12:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=LQc+0S/5hoswS6loTaAL6Rv174QFMlcyud786ylmTG6tdY7djIjYKqrRGs9KwhosWfPVWU9XvRBBC8DH9fLumw5Ra15sAjTExQmOHvSA424PMoFAtusEP/794IO/8qLr;
Date: Fri, 9 Apr 2010 15:12:56 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>, James Simmons <jsimmons@infradead.org>
Subject: [PATCH] fbcon: assume console is active if panicing
Message-ID: <20100409151256.7c3cdaaa@virtuousgeek.org>
In-Reply-To: <20100409151050.74ef6dcd@virtuousgeek.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to draw to the fbcon buffer in a panic situation, in case
the low level driver can flip to it at panic time.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/video/console/fbcon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index b0a3fa0..6ca1051 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -283,7 +283,7 @@ static inline int fbcon_is_inactive(struct vc_data *vc, struct fb_info *info)
 	struct fbcon_ops *ops = info->fbcon_par;
 
 	return (info->state != FBINFO_STATE_RUNNING ||
-		vc->vc_mode != KD_TEXT || ops->graphics);
+		vc->vc_mode != KD_TEXT || ops->graphics) && !oops_in_progress;
 }
 
 static inline int get_color(struct vc_data *vc, struct fb_info *info,
-- 
1.6.6.1

