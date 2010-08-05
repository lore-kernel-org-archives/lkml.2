Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174Ab0HEUWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:22:50 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:55606 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990Ab0HEUWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:22:47 -0400
Date: Thu, 5 Aug 2010 22:22:44 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 19/42] drivers/media/video: Adjust confusing if indentation
Message-ID: <Pine.LNX.4.64.1008052222220.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In cx23885/cx23885-video.c, cx88/cx88-video.c, davinci/vpif_capture.c, and
davinci/vpif_display.c, group the aligned code into a single if branch.

In saa7134/saa7134-video.c, outdent the code following the if.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r disable braces4@
position p1,p2;
statement S1,S2;
@@

(
if (...) { ... }
|
if (...) S1@p1 S2@p2
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

if (p1[0].column == p2[0].column):
  cocci.print_main("branch",p1)
  cocci.print_secs("after",p2)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
The patch changes the semantics for the first four files, and might not be
what is intended.

 drivers/media/video/cx23885/cx23885-video.c |    3 ++-
 drivers/media/video/cx88/cx88-video.c       |    3 ++-
 drivers/media/video/davinci/vpif_capture.c  |    3 ++-
 drivers/media/video/davinci/vpif_display.c  |    3 ++-
 drivers/media/video/saa7134/saa7134-video.c |    2 +-
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 4e44dcd..0f48967 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1165,9 +1165,10 @@ static int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i)
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name, iname[INPUT(n)->type]);
 	if ((CX23885_VMUX_TELEVISION == INPUT(n)->type) ||
-		(CX23885_VMUX_CABLE == INPUT(n)->type))
+		(CX23885_VMUX_CABLE == INPUT(n)->type)) {
 		i->type = V4L2_INPUT_TYPE_TUNER;
 		i->std = CX23885_NORMS;
+	}
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 0fab65c..4fba913 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1267,9 +1267,10 @@ int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i)
 	i->type  = V4L2_INPUT_TYPE_CAMERA;
 	strcpy(i->name,iname[INPUT(n).type]);
 	if ((CX88_VMUX_TELEVISION == INPUT(n).type) ||
-	    (CX88_VMUX_CABLE      == INPUT(n).type))
+	    (CX88_VMUX_CABLE      == INPUT(n).type)) {
 		i->type = V4L2_INPUT_TYPE_TUNER;
 		i->std = CX88_NORMS;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(cx88_enum_input);
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index a7f48b5..2b42473 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -1030,9 +1030,10 @@ static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 			goto qbuf_exit;
 
 		if ((VIDEOBUF_NEEDS_INIT != buf1->state)
-			    && (buf1->baddr != tbuf.m.userptr))
+			    && (buf1->baddr != tbuf.m.userptr)) {
 			vpif_buffer_release(&common->buffer_queue, buf1);
 			buf1->baddr = tbuf.m.userptr;
+		}
 		break;
 
 	default:
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index da07607..4770fda 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -935,9 +935,10 @@ static int vpif_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 			goto qbuf_exit;
 
 		if ((VIDEOBUF_NEEDS_INIT != buf1->state)
-			    && (buf1->baddr != tbuf.m.userptr))
+			    && (buf1->baddr != tbuf.m.userptr)) {
 			vpif_buffer_release(&common->buffer_queue, buf1);
 			buf1->baddr = tbuf.m.userptr;
+		}
 		break;
 
 	default:
diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
index 45f0ac8..645224c 100644
--- a/drivers/media/video/saa7134/saa7134-video.c
+++ b/drivers/media/video/saa7134/saa7134-video.c
@@ -1825,7 +1825,7 @@ static int saa7134_querycap(struct file *file, void  *priv,
 
 	if ((tuner_type == TUNER_ABSENT) || (tuner_type == UNSET))
 		cap->capabilities &= ~V4L2_CAP_TUNER;
-		return 0;
+	return 0;
 }
 
 int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_std_id *id)
