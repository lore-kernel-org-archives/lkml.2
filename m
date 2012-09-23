Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2IWRji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 13:39:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2IWRjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 13:39:37 -0400
Message-ID: <505F4949.2090509@redhat.com>
Date: Sun, 23 Sep 2012 14:39:21 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
CC: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Fwd: [PATCH 5/5] drivers/media/platform/omap3isp/isp.c: fix error
 return code
References: <1346775269-12191-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1346775269-12191-1-git-send-email-peter.senna@gmail.com>
X-Enigmail-Version: 1.4.4
X-Forwarded-Message-Id: <1346775269-12191-1-git-send-email-peter.senna@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090503090104080708050501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090503090104080708050501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Laurent,

Could you please review this patch?

Peter,

Please, always c/c the driver maintainer/author on patches you submit.

You can check it with scripts/get_maintainer.pl.

Regards,
Mauro

-------- Mensagem original --------
Assunto: [PATCH 5/5] drivers/media/platform/omap3isp/isp.c: fix error return code
Data: Tue,  4 Sep 2012 18:14:25 +0200
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
 drivers/media/platform/omap3isp/isp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index e0096e0..91fcaef 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2102,8 +2102,10 @@ static int __devinit isp_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
-	if (__omap3isp_get(isp, false) == NULL)
+	if (__omap3isp_get(isp, false) == NULL) {
+		ret = -EBUSY; /* Not sure if EBUSY is best for here */
 		goto error;
+	}
 
 	ret = isp_reset(isp);
 	if (ret < 0)

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------090503090104080708050501
Content-Type: text/plain; charset=UTF-8;
 name="=?ISO-8859-1?Q?Se=E7=E3o_da_mensagem_anexada?="
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0*=ISO-8859-1''%53%65%E7%E3%6F%20%64%61%20%6D%65%6E%73%61%67%65;
 filename*1*=%6D%20%61%6E%65%78%61%64%61


--------------090503090104080708050501--
