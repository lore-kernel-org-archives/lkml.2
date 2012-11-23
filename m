Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab2KWG5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 01:57:10 -0500
Received: from smtp.nue.novell.com ([195.135.221.5]:45333 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab2KWG5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 01:57:08 -0500
Subject: Re: [PATCH RFC v2 3/4] firmware: Add support for signature checks
From: joeyli <jlee@suse.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
In-Reply-To: <1352396109-3989-4-git-send-email-tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de>
	 <1352396109-3989-1-git-send-email-tiwai@suse.de>
	 <1352396109-3989-4-git-send-email-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Nov 2012 14:56:11 +0800
Message-ID: <1353653771.21227.741.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2012-11-08 於 18:35 +0100，Takashi Iwai 提到：
> +#ifdef CONFIG_FIRMWARE_SIG
> +static int verify_sig_file(struct firmware_buf *buf, const char
> *path)
> +{
> +       const unsigned long markerlen = sizeof(FIRMWARE_SIG_STRING) -
> 1;
> +       struct file *file;
> +       void *sig_data;
> +       size_t sig_size;
> +       int ret;
> +
> +       file = filp_open(path, O_RDONLY, 0);
> +       if (IS_ERR(file))
> +               return -ENOKEY;

I think there should return '-ENOENT', otherwise the firmware will show
'Invalid firmware signature' even didn't find the sig file.

> +
> +       ret = fw_read_file_contents(file, &sig_data, &sig_size);
> +       fput(file); 

Tested-by: Chun-Yi Lee <jlee@suse.com>

Thanks a lot!
Joey Lee

