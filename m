Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2IWTfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:35:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2IWTfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:35:21 -0400
Message-ID: <505F6461.8090401@redhat.com>
Date: Sun, 23 Sep 2012 16:34:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>
Subject: Fwd: [PATCH 2/14] drivers/media/platform/soc_camera/mx2_camera.c:
 fix error return code
References: <1346945041-26676-12-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1346945041-26676-12-git-send-email-peter.senna@gmail.com>
X-Enigmail-Version: 1.4.4
X-Forwarded-Message-Id: <1346945041-26676-12-git-send-email-peter.senna@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020800040104010701040105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020800040104010701040105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Please review,

Regards,
Mauro.


-------- Mensagem original --------
Assunto: [PATCH 2/14] drivers/media/platform/soc_camera/mx2_camera.c: fix error return code
Data: Thu,  6 Sep 2012 17:23:59 +0200
De: Peter Senna Tschudin <peter.senna@gmail.com>
Para: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr, linux-media@vger.kernel.org, linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

Convert a nonnegative error return code to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/platform/soc_camera/mx2_camera.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 256187f..f8884a7 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1800,13 +1800,16 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
 
 		if (!res_emma || !irq_emma) {
 			dev_err(&pdev->dev, "no EMMA resources\n");
+			err = -ENODEV;
 			goto exit_free_irq;
 		}
 
 		pcdev->res_emma = res_emma;
 		pcdev->irq_emma = irq_emma;
-		if (mx27_camera_emma_init(pcdev))
+		if (mx27_camera_emma_init(pcdev)) {
+			err = -ENODEV;
 			goto exit_free_irq;
+		}
 	}
 
 	pcdev->soc_host.drv_name	= MX2_CAM_DRV_NAME,

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------020800040104010701040105
Content-Type: text/plain; charset=UTF-8;
 name="=?ISO-8859-1?Q?Se=E7=E3o_da_mensagem_anexada?="
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0*=ISO-8859-1''%53%65%E7%E3%6F%20%64%61%20%6D%65%6E%73%61%67%65;
 filename*1*=%6D%20%61%6E%65%78%61%64%61


--------------020800040104010701040105--
