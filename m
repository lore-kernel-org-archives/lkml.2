Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1KYWEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 17:04:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45422 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab1KYWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 17:04:53 -0500
Date: Sat, 26 Nov 2011 02:04:48 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 8/9] bq27x00: Add miscdevice for each battery with ioctl
 for reading registers
Message-ID: <20111125220448.GA2078@oksana.dev.rtsoft.ru>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com>
 <7780165.E3DXgdWAv1@pali-elitebook>
 <20111125204626.GA25003@oksana.dev.rtsoft.ru>
 <33058541.3DK13LYaLI@pali-elitebook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <33058541.3DK13LYaLI@pali-elitebook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 09:54:04PM +0100, Pali Rohár wrote:
> On Saturday 26 November 2011 00:46:26 Anton Vorontsov wrote:
> > On Fri, Nov 25, 2011 at 09:30:28PM +0100, Pali Rohár wrote:
> > [...]
> > 
> > > This interface is not only for BME. Also some popular bq27200.sh script
> > > which print bq registers in human readable form needs this interface
> > > (with LD_PRELOAD library).
> > > 
> > > Link for that shell script http://enivax.net/jk/n900/bq.tar
> > 
> > That might be a good excuse to have the raw interface. Although,
> > as this is for debugging purposes only, the same effect can be
> > accomplished by unloading bq module and using i2c userspace
> > interface directly... I guess.
> > 
> 
> Yes, unloading bq module and then starting script working. But I think that we 
> could have some interface how to access directly to i2c when some i2c module 
> for chip is loaded.

This would be not safe as this might (in case of RW registers)
break kernel's driver behaviour (well, in bq case you only allow
reading, so not problem in this particular case).

What would be more practical, is to allow I2C core to provide
userspace interface even for already bound I2C devices.

That could be some kind of CONFIG_I2C_UNSAFE_DEBUG: when
selected I2C core would allow access to all I2C devices. But still,
the niche for such a feature is tiny, so I doubt that it is worth
doing at all.

In any case, I just think that being able to access already bound
I2C devices from userspace might be a good thing for debugging,
but having such an interface per-driver is impractical.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
