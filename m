Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab0GTLP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 07:15:28 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46831 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab0GTLP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 07:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WKzuGbKh/9aFzUCHaEK6P7NGeWDV+muHTmAnyGcFjZSz9Oor8+rkwry4u7VWtB4anf
         GfyvtFJYr84EWm+1G5ZgguBFScJA3ZA8RsbuljktHe4/JIQcKBm4GdNL27m8ecCoEUqP
         Fp5cy7fsKi/RSDKyRZVY82B6L5FFHZiygIo+o=
Date: Tue, 20 Jul 2010 15:15:21 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] battery-2.6.35.git
Message-ID: <20100720111521.GA23383@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull a small fixup for the ds2782_battery driver.

Thanks,


The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:
  Linus Torvalds (1):
        Linux 2.6.35-rc3

are available in the git repository at:

  git://git.infradead.org/users/cbou/battery-2.6.35.git master

Ryan Mallon (1):
      ds2782_battery: Fix ds2782_get_capacity return value

 drivers/power/ds2782_battery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 2d31757c87a741823f77daaa07eeb8d56be63943
Author: Ryan Mallon <ryan@bluewatersys.com>
Date:   Tue Jun 15 12:44:59 2010 +1200

    ds2782_battery: Fix ds2782_get_capacity return value
    
    The ds2782_get_capacity function should return 0 on success, not the
    capacity value.
    
    Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
    Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>

diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
index d762a0c..2afbeec 100644
--- a/drivers/power/ds2782_battery.c
+++ b/drivers/power/ds2782_battery.c
@@ -163,7 +163,7 @@ static int ds2782_get_capacity(struct ds278x_info *info, int *capacity)
 	if (err)
 		return err;
 	*capacity = raw;
-	return raw;
+	return 0;
 }
 
 static int ds2786_get_current(struct ds278x_info *info, int *current_uA)

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
