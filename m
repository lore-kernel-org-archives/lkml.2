Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936333Ab2C3Vwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:52:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54199 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838Ab2C3VTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:19:43 -0400
Message-Id: <20120330194835.596223934@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>
Subject: [ 059/175] mlx4_core: Fix one more static exported function
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit e10903b087e425298fb86c6ad4b1a88735480db7 upstream.

Commit 22c8bff6face ("mlx4_core: Exported functions can't be static")
fixed most of this up, but forgot about mlx4_is_slave_active().  Fix
this one too.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -394,7 +394,7 @@ static int mlx4_how_many_lives_vf(struct
 	return ret;
 }
 
-static int mlx4_is_slave_active(struct mlx4_dev *dev, int slave)
+int mlx4_is_slave_active(struct mlx4_dev *dev, int slave)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_slave_state *s_slave;


