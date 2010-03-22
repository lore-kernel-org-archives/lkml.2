Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0CVNOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:14:10 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41050 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0CVNOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:14:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WrOhpN03XObLfg+BH/FVbRi0dP8i9iU6u/H1btCLSd3OIdqMmmpiN9yAUiv+m9CNRi
         ZgCYxw+HV3b/VKw/6BZyKl7vQJGbZtWj2v8/lt96p9Z04sx2OjPvofHlA/PhpfeZRpDi
         3TL66KrtF6m9fyzbLthFbrpiby4VhNBIjzf4g=
Date: Mon, 22 Mar 2010 15:15:08 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: "Eric W.  Biederman" <ebiederm@xmission.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
       Len Brown <lenb@kernel.org>
Subject: [PATCH] Fix key f70f4b50 not in .data in thermal_sys
Message-ID: <20100322131508.GB3596@swordfish.minsk.epam.com>
References: <20100309102754.GA3316@swordfish.minsk.epam.com>
 <20100309141826.GC28606@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wzJLGUyc3ArbnUjN"
Content-Disposition: inline
In-Reply-To: <20100309141826.GC28606@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wzJLGUyc3ArbnUjN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Initialize sysfs attributes before device_create_file call.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 5066de5..a76a6ff 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -492,6 +492,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 		goto free_mem;
 	}
 	dev_set_drvdata(hwmon->device, hwmon);
+	sysfs_attr_init(&dev_attr_name.attr);
 	result = device_create_file(hwmon->device, &dev_attr_name);
 	if (result)
 		goto unregister_hwmon_device;
@@ -505,6 +506,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 	tz->temp_input.attr.attr.name = tz->temp_input.name;
 	tz->temp_input.attr.attr.mode = 0444;
 	tz->temp_input.attr.show = temp_input_show;
+	sysfs_attr_init(&tz->temp_input.attr.attr);
 	result = device_create_file(hwmon->device, &tz->temp_input.attr);
 	if (result)
 		goto unregister_hwmon_device;
@@ -517,6 +519,7 @@ thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 			tz->temp_crit.attr.attr.name = tz->temp_crit.name;
 			tz->temp_crit.attr.attr.mode = 0444;
 			tz->temp_crit.attr.show = temp_crit_show;
+			sysfs_attr_init(&tz->temp_crit.attr.attr);
 			result = device_create_file(hwmon->device,
 						    &tz->temp_crit.attr);
 			if (result)

--wzJLGUyc3ArbnUjN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkunbVwACgkQfKHnntdSXjQt3AQA3NnoKS/Jcgqn/o9iOaj1lvlW
WI0fwNOjEF22kbbLNVPtekMdVG5/4TpC8gBv1bu0sVr+TZ5D8gLHQdmAe1wB16LY
PZoABj7sQmTMN6T3mRk5yQxZ8aRjUxfPOio7zT3hGrmD2DDwXVO41ZMdwOwuYRwn
mabL/fv2DnsoE2AOwTY=
=kAOs
-----END PGP SIGNATURE-----

--wzJLGUyc3ArbnUjN--
