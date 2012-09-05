Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2IEHbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:31:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2IEHbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:31:09 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, jikos@suse.cz
Subject: Re: [eBeam PATCH 2/2] input: misc: New USB eBeam input driver.
Date: Wed, 05 Sep 2012 09:29:49 +0200
Message-ID: <3991181.oZKWSZGdK8@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc2-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1346539923-9704-3-git-send-email-yann.cantin@laposte.net>
References: <1346539923-9704-1-git-send-email-yann.cantin@laposte.net> <1346539923-9704-3-git-send-email-yann.cantin@laposte.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 September 2012 00:52:03 Yann Cantin wrote:

Hi,

before we add yet another sysfs interface, we should ask whether calibration
isn't a problem that should be solved with a common API.

	Regards
		Oliver

> +static ssize_t ebeam_calibrated_set(struct device *dev,
> +                                   struct device_attribute *attr,
> +                                   const char *buf,
> +                                   size_t count)
> +{
> +       struct ebeam_device *ebeam = dev_get_drvdata(dev);
> +       int err, c;
> +
> +       err = kstrtoint(buf, 10, &c);
> +       if (err)
> +               return err;
> +
> +       if (c == 1) {
> +               memcpy(&ebeam->cursetting, &ebeam->newsetting,
> +                      sizeof(struct ebeam_settings));
> +               ebeam->calibrated = true;
> +               ebeam_setup_input(ebeam, ebeam->input);
> +       } else {
> +               memcpy(&ebeam->newsetting, &ebeam->cursetting,
> +                      sizeof(struct ebeam_settings));
> +               ebeam->calibrated = false;
> +               ebeam_setup_input(ebeam, ebeam->input);
> +       }
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(calibrated, S_IRUGO | S_IWUGO,
> +                  ebeam_calibrated_get, ebeam_calibrated_set);
> +
> +static struct attribute *ebeam_attrs[] = {
> +       &dev_attr_min_x.attr,
> +       &dev_attr_min_y.attr,
> +       &dev_attr_max_x.attr,
> +       &dev_attr_max_y.attr,
> +       &dev_attr_h1.attr,
> +       &dev_attr_h2.attr,
> +       &dev_attr_h3.attr,
> +       &dev_attr_h4.attr,
> +       &dev_attr_h5.attr,
> +       &dev_attr_h6.attr,
> +       &dev_attr_h7.attr,
> +       &dev_attr_h8.attr,
> +       &dev_attr_h9.attr,
> +       &dev_attr_calibrated.attr,
> +       NULL
> +};
> +
-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
