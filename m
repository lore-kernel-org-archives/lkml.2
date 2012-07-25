Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2GYQC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:02:28 -0400
Received: from osrc3.amd.com ([217.9.48.20]:36457 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755769Ab2GYQC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:02:27 -0400
Date: Wed, 25 Jul 2012 18:02:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/13] driver core: firmware loader: always let
 firmware_buf own the pages buffer
Message-ID: <20120725160221.GJ11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-7-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343149213-10160-7-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:06AM +0800, Ming Lei wrote:
> @@ -750,6 +835,7 @@ request_firmware_nowait(

while you're here, can you fix the arg alignment of this
request_firmware_nowait - it looks awful right now:

int
request_firmware_nowait(
        struct module *module, bool uevent,
        const char *name, struct device *device, gfp_t gfp, void *context,
        void (*cont)(const struct firmware *fw, void *context))
{

and it could like, say, this:

int request_firmware_nowait(struct module *module, bool uevent, const char *name,
			    struct device *device, gfp_t gfp, void *context,
			    void (*cont)(const struct firmware *fw, void *context))
{

or something even more readable.

>  static int __init firmware_class_init(void)
>  {
> +	fw_cache_init();
>  	return class_register(&firmware_class);
>  }
>  
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index 1e7c011..e85b771 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -12,6 +12,9 @@ struct firmware {
>  	size_t size;
>  	const u8 *data;
>  	struct page **pages;
> +
> +	/* firmware loader private fields */
> +	void *priv;
>  };
>  
>  struct module;

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
