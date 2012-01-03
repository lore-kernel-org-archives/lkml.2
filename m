Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2ACXGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:06:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928Ab2ACWfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:35:33 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:33 2012
Message-Id: <20120103223033.641584736@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:45 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [27/67] media: s5p-fimc: Use correct fourcc for RGB565 colour format
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

commit f83f71fda27650ae43558633be93652577dbc38c upstream.

With 16-bit RGB565 colour format pixels are stored by the device in memory
in the following order:

    | b3  | b2  | b1  | b0  |
   ~+-----+-----+-----+-----+
    | R5 G6 B5  | R5 G6 B5  |

This corresponds to V4L2_PIX_FMT_RGB565 fourcc, not V4L2_PIX_FMT_RGB565X.
This change is required to avoid trouble when setting up video pipeline
with the s5p-tv devices, so the colour formats at both devices can be
properly matched.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -36,7 +36,7 @@ static char *fimc_clocks[MAX_FIMC_CLOCKS
 static struct fimc_fmt fimc_formats[] = {
 	{
 		.name		= "RGB565",
-		.fourcc		= V4L2_PIX_FMT_RGB565X,
+		.fourcc		= V4L2_PIX_FMT_RGB565,
 		.depth		= { 16 },
 		.color		= S5P_FIMC_RGB565,
 		.memplanes	= 1,


