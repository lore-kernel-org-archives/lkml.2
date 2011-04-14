Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab1DNAko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 20:40:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43218 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1DNAkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 20:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp
         :x-pgp:date:in-reply-to:message-id:user-agent:mime-version
         :content-type;
        b=ffkosK2gbbfmIAxFSkS7pbgiZ8J75ioHcSScsdbIZdU35UHCbdvULVnE+iTDyDbIoo
         xnzaIG/wADzF5uoBrTvO7sKDM2ewA581NuGJqhNvj+oNcigqM9SgpDe7tYlo5JBTa3f4
         nFZGD8xeDNVjSWzPaqVO10aD+dQokEpLc5GB4=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2] usb: gadget: storage_common: use kstrto*()
References: <c7bc1074f7cd049786ac2d50fe71b5e3ca0beba2.1302732994.git.mina86@mina86.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Thu, 14 Apr 2011 02:40:39 +0200
In-Reply-To: <c7bc1074f7cd049786ac2d50fe71b5e3ca0beba2.1302732994.git.mina86@mina86.com>
	(Michal Nazarewicz's message of "Thu, 14 Apr 2011 00:37:00 +0200")
Message-ID: <8739llk6m0.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit replaces the usage of strict_strtoul() (which
became deprecated after commit 33ee3b2e) with kstrtouint().

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/storage_common.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

> @@ -711,10 +711,11 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
>  	ssize_t		rc = count;
>  	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
>  	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
> -	unsigned long	ro;
> +	unsigned	ro;
>  
> -	if (strict_strtoul(buf, 2, &ro))
> -		return -EINVAL;
> +	rc = kstrtouint(buf, 2, &ro);
> +	if (rc)
> +		return rc;
>  

Sorry, I've just noticed this zeroes the rc so that the function returns
invalid read length.  Attached patch has the following delta included:

| @@ -708,7 +708,7 @@ static ssize_t fsg_show_file(struct device *dev, struct devi
|  static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
|                             const char *buf, size_t count)
|  {
| -       ssize_t         rc = count;
| +       ssize_t         rc;
|         struct fsg_lun  *curlun = fsg_lun_from_dev(dev);
|         struct rw_semaphore     *filesem = dev_get_drvdata(dev);
|         unsigned        ro;
| @@ -729,6 +729,7 @@ static ssize_t fsg_store_ro(struct device *dev, struct devic
|                 curlun->ro = ro;
|                 curlun->initially_ro = ro;
|                 LDBG(curlun, "read-only status set to %d\n", curlun->ro);
| +               rc = count;
|         }
|         up_read(filesem);
|         return rc;


diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index b015561..1fa4f70 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -708,13 +708,14 @@ static ssize_t fsg_show_file(struct device *dev, struct device_attribute *attr,
 static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 			    const char *buf, size_t count)
 {
-	ssize_t		rc = count;
+	ssize_t		rc;
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
 	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
-	unsigned long	ro;
+	unsigned	ro;
 
-	if (strict_strtoul(buf, 2, &ro))
-		return -EINVAL;
+	rc = kstrtouint(buf, 2, &ro);
+	if (rc)
+		return rc;
 
 	/*
 	 * Allow the write-enable status to change only while the
@@ -728,6 +729,7 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
 		curlun->ro = ro;
 		curlun->initially_ro = ro;
 		LDBG(curlun, "read-only status set to %d\n", curlun->ro);
+		rc = count;
 	}
 	up_read(filesem);
 	return rc;
@@ -738,10 +740,12 @@ static ssize_t fsg_store_nofua(struct device *dev,
 			       const char *buf, size_t count)
 {
 	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
-	unsigned long	nofua;
+	unsigned	nofua;
+	int		ret;
 
-	if (strict_strtoul(buf, 2, &nofua))
-		return -EINVAL;
+	ret = kstrtouint(buf, 2, &nofua);
+	if (ret)
+		return ret;
 
 	/* Sync data when switching from async mode to sync */
 	if (!nofua && curlun->nofua)
