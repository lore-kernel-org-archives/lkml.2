Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab2KFHbA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:31:00 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41381 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab2KFHa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:30:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAGB3EUTrSMDhja9Gu3h7nuZX+H2_owp8MnUNwbZuCW=_GuawqQ@mail.gmail.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
	<CACVXFVN8qPTgiYKXaeKFJXLXMjLE=+=8Vev2otD3v1VMk+Ez_w@mail.gmail.com>
	<CAGB3EUTrSMDhja9Gu3h7nuZX+H2_owp8MnUNwbZuCW=_GuawqQ@mail.gmail.com>
Date: Tue, 6 Nov 2012 15:30:57 +0800
Message-ID: <CACVXFVMBq7PwOH_CwETW-uFrYL5sR9ChtOrpSOqhWWchC06HWQ@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
From: Ming Lei <tom.leiming@gmail.com>
To: Li Joey <jlee@novell.com>
Cc: Takashi Iwai <tiwai@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 1:36 PM, Li Joey <jlee@novell.com> wrote:

> The udev direct write firmware through data attribute, maybe we can do the
> same signature verification in firmware_data_write? The following patch
> didn't test yet.

> @@ -655,6 +656,23 @@ static ssize_t firmware_data_write(struct file *filp,
> struct kobject *kobj,
>         }
>
>         buf->size = max_t(size_t, offset, buf->size);
> +
> +#ifdef CONFIG_FIRMWARE_SIG
> +       for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
> +               snprintf(path, PATH_MAX, "%s/%s.sig", fw_path[i],
> buf->fw_id);
> +               if (verify_signature(buf, path))
> +                       success = true;
> +       }

When direct loading failed, it means that the firmware isn't
under the default search path, so the above verification
might return false always.


Thanks,
-- 
Ming Lei
