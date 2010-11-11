Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0KKJAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:00:24 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45242 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0KKJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:00:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ay+4IyPKtDZhSVWM23cr2/FEj8h5rjCfI9Ybza3s1kcqUe2lzXpg5ViEovVRZ746In
         XLHLBeTtBAokD6DaGc8yCjQjyYaekOBn+6K4SmuFGJ5RSGAKLf8ck8xhOXP4EbKsvqCj
         +oVaQzo5Eyp9lOuDzvoKN1XYftUOsVVIEAsIw=
Date: Thu, 11 Nov 2010 01:00:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Achatz <erazor_de@users.sourceforge.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Stephane Chatty <chatty@enac.fr>,
        Don Prince <dhprince-devel@yahoo.co.uk>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] HID: roccat: Add support for Roccat Kone[+]
Message-ID: <20101111090015.GG24415@core.coreip.homeip.net>
References: <1287943025.2623.16.camel@neuromancer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287943025.2623.16.camel@neuromancer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Sun, Oct 24, 2010 at 07:57:05PM +0200, Stefan Achatz wrote:
> +
> +static int koneplus_create_sysfs_attributes(struct usb_interface *intf)
> +{
> +	int retval;
> +
> +	retval = sysfs_create_group(&intf->dev.kobj, &koneplus_attribute_group);
> +	if (retval)
> +		goto exit_1;
> +
> +	retval = sysfs_create_bin_file(&intf->dev.kobj,
> +			&koneplus_profile_settings_attr);
> +	if (retval)
> +		goto exit_2;
> +
> +	retval = sysfs_create_bin_file(&intf->dev.kobj,
> +			&koneplus_profile1_settings_attr);
> +	if (retval)
> +		goto exit_3;
> +

...

> +
> +	retval = sysfs_create_bin_file(&intf->dev.kobj,
> +			&koneplus_sensor_attr);
> +	if (retval)
> +		goto exit_17;
> +

I think we are ready to sysfs_binary_attribute_group ;) Please add it to
sysfs code and send it to GregKH.

Thanks.

-- 
Dmitry
