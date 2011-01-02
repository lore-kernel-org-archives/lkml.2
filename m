Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab1ABIqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:46:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33872 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab1ABIqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 03:46:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LWEucuyqLRQw96TqvmygS0uawGblqch8fyBGEm4NrYj+1dVAnh93IPbhyqZ46Jex40
         fiqDT9/3XLB6vfnKCbbmbtIhFRNN1feUBKFUHn/snvEEbBO6Zpn6MzueqwQyHIIkP1Qj
         ZVEurdcNsHoLagyc09iSVYZMXlGfBFB5s+os8=
Date: Sat, 1 Jan 2011 23:58:53 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver (second version)
Message-ID: <20110102075852.GB5429@core.coreip.homeip.net>
References: <4D1C60F1.5090305@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1C60F1.5090305@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 11:37:37AM +0100, Fabien Marteau wrote:
> +
> +	plat_dat->input_dev->name = "Austria Microsystem as5011 joystick";
> +	plat_dat->input_dev->uniq = "Austria0";

This is improper value for 'uniq' which has to be globally unique
identifier (across systems). like a serial number.

> +	plat_dat->input_dev->id.bustype = BUS_I2C;
> +	plat_dat->input_dev->phys = NULL;

No need to set this to NULL.

> +	plat_dat->input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	plat_dat->input_dev->keybit[BIT_WORD(BTN_JOYSTICK)] =
> +					BIT_MASK(BTN_JOYSTICK);

__set_bit() is shorter and generally safer (no chance of writing to
wrong longword).

-- 
Dmitry
