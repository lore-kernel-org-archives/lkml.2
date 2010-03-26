Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0CZG5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 02:57:07 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:61602 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab0CZG5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 02:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CaBOzONkM0v6GJUfuu95TJy+IYLoHJGtNN/5QILz758Z5tBe1cDRdeHRhdMDdzNhtY
         QIwWcOSaoa7gb8nUJ7Jgs7azcjulPhTBUt5lDeGAkitkd4cBcxnw+vKIicJbBI7H1fk5
         rXmeslTKHhF5+S48cVRHnMsSW6sbCY/q3d+gE=
Date: Thu, 25 Mar 2010 23:56:57 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v3 1/6] hid: new driver for PicoLCD device
Message-ID: <20100326065656.GC26602@core.coreip.homeip.net>
References: <20100324233707.7243b04d@neptune.home>
 <20100324234022.0361bd80@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100324234022.0361bd80@neptune.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 11:40:22PM +0100, Bruno Prémont wrote:
> +	for (i = 0; i < PICOLCD_KEYS; i++) {
> +		int key = ((int *)idev->keycode)[i];

Keycodes are now short, not int. Also, just do:

		input_set_capability(idev, EV_KEY, data->keycode[i]);

> +		if (key < KEY_MAX && key >= 0)
> +			input_set_capability(idev, EV_KEY, key);
-- 
Dmitry
