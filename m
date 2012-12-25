Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2LYWAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 17:00:44 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45612 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2LYWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 17:00:42 -0500
Message-ID: <50DA2207.3010807@ubuntu.com>
Date: Tue, 25 Dec 2012 22:00:39 +0000
From: Michael Rawson <michael.rawson@ubuntu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] cdrom: remove extraneous braces to comply with coding style.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list, Jens.
Please note that I'm a kernel newbie, hope I'm not about to embarrass myself. :-)

 From https://github.com/torvalds/linux/blob/master/Documentation/CodingStyle:

"Printing numbers in parentheses (%d) adds no value and should be avoided."

I saw a couple of parenthesized messages in the cdrom driver I was looking at, have edited them out as a first patch.
I intend this for the mainline branch, though given the patch content I can't see a reason why it wouldn't work elsewhere.

Patch follows:

--- linux-clean/drivers/cdrom/cdrom.c	2012-12-25 20:48:07.130718725 +0000
+++ linux/drivers/cdrom/cdrom.c	2012-12-25 19:49:01.080357984 +0000
@@ -1759,7 +1759,7 @@ static int dvd_do_auth(struct cdrom_devi
  		break;

  	default:
-		cdinfo(CD_WARNING, "Invalid DVD key ioctl (%d)\n", ai->type);
+		cdinfo(CD_WARNING, "Invalid DVD key ioctl %d\n", ai->type);
  		return -ENOTTY;
  	}

@@ -1891,7 +1891,7 @@ static int dvd_read_bca(struct cdrom_dev

  	s->bca.len = buf[0] << 8 | buf[1];
  	if (s->bca.len < 12 || s->bca.len > 188) {
-		cdinfo(CD_WARNING, "Received invalid BCA length (%d)\n", s->bca.len);
+		cdinfo(CD_WARNING, "Received invalid BCA length %d\n", s->bca.len);
  		ret = -EIO;
  		goto out;
  	}
@@ -1928,12 +1928,12 @@ static int dvd_read_manufact(struct cdro
  	s->manufact.len = buf[0] << 8 | buf[1];
  	if (s->manufact.len < 0) {
  		cdinfo(CD_WARNING, "Received invalid manufacture info length"
-				   " (%d)\n", s->manufact.len);
+				   " %d\n", s->manufact.len);
  		ret = -EIO;
  	} else {
  		if (s->manufact.len > 2048) {
  			cdinfo(CD_WARNING, "Received invalid manufacture info "
-					"length (%d): truncating to 2048\n",
+					"length %d: truncating to 2048\n",
  					s->manufact.len);
  			s->manufact.len = 2048;
  		}
@@ -1965,7 +1965,7 @@ static int dvd_read_struct(struct cdrom_
  		return dvd_read_manufact(cdi, s, cgc);
  		
  	default:
-		cdinfo(CD_WARNING, ": Invalid DVD structure read requested (%d)\n",
+		cdinfo(CD_WARNING, ": Invalid DVD structure read requested %d\n",
  					s->type);
  		return -EINVAL;
  	}


"Signed-off-by: Michael Rawson <michael.rawson@ubuntu.com>"

If you guys think it's unimportant, appreciated, but suggestions on a better first patch would be good too.
Thanks for attention, criticism on submission would be appreciated.

Happy Christmas (or just have a good day if not),

Michael.

