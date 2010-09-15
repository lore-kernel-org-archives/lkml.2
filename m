Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0IOGfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 02:35:07 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34105 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0IOGfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 02:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s1cXa6fQ2pnSLthR3MvzO0bErIoOGUTm8FY8j/pOvLHLITf62D3SUoEcbW7+xG2zgs
         aXo2sCIOE46mgwLp16GnepIr1Hy22GYga8wwQ+9El1ENvmpH0xZH/fMmHb8VcUAYmbBu
         zoIgoCs4hTZju23HF7/GOrOedoIMe+s6KPoeo=
Date: Wed, 15 Sep 2010 09:35:18 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        Eric Sandeen <sandeen@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: fix NULL pointer dereference in
 print_daily_error_info
Message-ID: <20100915063517.GA8456@swordfish.minsk.epam.com>
References: <20100914125102.GA5318@swordfish.minsk.epam.com>
 <20100914194641.GB3730@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914194641.GB3730@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NULL pointer dereference in print_daily_error_info, when   
called on unmounted fs (EXT4_SB(sb) returns NULL), by removing error 
reporting timer in ext4_put_super.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2614774..751997d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -719,6 +719,7 @@ static void ext4_put_super(struct super_block *sb)
 			ext4_abort(sb, "Couldn't clean up the journal");
 	}
 
+	del_timer(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);


