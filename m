Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2IWTau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:30:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853Ab2IWTat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:30:49 -0400
Message-ID: <505F6362.5090602@redhat.com>
Date: Sun, 23 Sep 2012 16:30:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Peter Senna Tschudin <peter.senna@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Fwd: [PATCH v2] drivers/media/platform/s5p-tv/sdo_drv.c: fix error
 return code
References: <1346920709-8711-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1346920709-8711-1-git-send-email-peter.senna@gmail.com>
X-Enigmail-Version: 1.4.4
X-Forwarded-Message-Id: <1346920709-8711-1-git-send-email-peter.senna@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050604020401000706090902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050604020401000706090902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sylwester,

Please review.

Regards,
Mauro

-------- Mensagem original --------
Assunto: [PATCH v2] drivers/media/platform/s5p-tv/sdo_drv.c: fix error return code
Data: Thu,  6 Sep 2012 10:38:29 +0200
De: Peter Senna Tschudin <peter.senna@gmail.com>
Para: peter.senna@gmail.com, Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org

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
 drivers/media/platform/s5p-tv/sdo_drv.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..58cf56d 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -369,6 +369,7 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->fout_vpll = clk_get(dev, "fout_vpll");
 	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
 		dev_err(dev, "failed to get clock 'fout_vpll'\n");
+		ret = -ENXIO;
 		goto fail_dacphy;
 	}
 	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
@@ -377,11 +378,13 @@ static int __devinit sdo_probe(struct platform_device *pdev)
 	sdev->vdac = devm_regulator_get(dev, "vdd33a_dac");
 	if (IS_ERR_OR_NULL(sdev->vdac)) {
 		dev_err(dev, "failed to get regulator 'vdac'\n");
+		ret = -ENXIO;
 		goto fail_fout_vpll;
 	}
 	sdev->vdet = devm_regulator_get(dev, "vdet");
 	if (IS_ERR_OR_NULL(sdev->vdet)) {
 		dev_err(dev, "failed to get regulator 'vdet'\n");
+		ret = -ENXIO;
 		goto fail_fout_vpll;
 	}
 

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



--------------050604020401000706090902
Content-Type: text/plain; charset=UTF-8;
 name="=?ISO-8859-1?Q?Se=E7=E3o_da_mensagem_anexada?="
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename*0*=ISO-8859-1''%53%65%E7%E3%6F%20%64%61%20%6D%65%6E%73%61%67%65;
 filename*1*=%6D%20%61%6E%65%78%61%64%61


--------------050604020401000706090902--
