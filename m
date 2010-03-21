Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0CUDIL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 23:08:11 -0400
Received: from mail-yw0-f172.google.com ([209.85.211.172]:47657 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0CUDII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 23:08:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=qJ00ihfOMU2symGvtumzkF+GEzsn3BnXzyYt3oUpVRgIXrivh4uYRLMf0dJpAXA5BW
         c3+pKOPa4/9d5TCAABJwFaxW4XVUeDRUzEgk2vAzYUrmLQKheDzoRoNokCIArgCp1OLl
         C2RE4EFpo0jXGCs3tsNDB4CLnowcbMNtzn8d8=
Date: Sat, 20 Mar 2010 20:08:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 6/6] hid: add experimental access to PicoLCD device's
 EEPROM and FLASH
Message-ID: <20100321030802.GB29360@core.coreip.homeip.net>
References: <20100320170014.440959a8@neptune.home>
 <20100320171119.193c5615@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100320171119.193c5615@neptune.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 05:11:19PM +0100, Bruno Prémont wrote:
> The PicoLCD device has a small amount of EEPROM and also provides
> access to its FLASH where firmware and splash image are saved.
> In flasher mode FLASH access is the only active feature.
> 
> Give read/write access to both via debugfs files.
> 

It looks you are allowing multiple users access to these files. What
will happen if 2 processes try to write EEPROM at the same time?

> +
> +static inline int picolcd_init_devfs(struct picolcd_data *data,
> +		struct hid_report *eeprom_r, struct hid_report *eeprom_w,
> +		struct hid_report *flash_r, struct hid_report *flash_w,
> +		struct hid_report *reset)
> +{

I don't think this should be forced inline.

Thanks.

-- 
Dmitry
