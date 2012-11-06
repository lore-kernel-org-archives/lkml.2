Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab2KFHQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 02:16:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51148 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2KFHQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 02:16:45 -0500
MIME-Version: 1.0
In-Reply-To: <s5h8vafi56z.wl%tiwai@suse.de>
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
	<s5h8vafi56z.wl%tiwai@suse.de>
Date: Tue, 6 Nov 2012 15:16:43 +0800
Message-ID: <CACVXFVPDZnXshvartbTt6gaGzcb+03sVq3Qm3apQQ8AVcQWerg@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
From: Ming Lei <tom.leiming@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 3:03 PM, Takashi Iwai <tiwai@suse.de> wrote:
>
> Yeah, it's just uncovered in the patch.  As a easy solution, apply the
> patch like below to disallow the udev fw loading when signature check
> is enforced.
>
>
> thanks,
>
> Takashi
>
> ---
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 575bc4c..93121c3 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -912,6 +912,13 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
>                 goto handle_fw;
>         }
>
> +       /* signature check isn't handled via udev fw loading */
> +       if (sig_enforce) {
> +               fw_load_abort(fw_priv);
> +               direct_load = 1;
> +               goto handle_fw;
> +       }
> +

The above might be wrong if the firmware file doesn't exist in default
search paths. You should skip loading from user space only if
verify_signature() returns false. And the udev loading should be
resorted to if there is no such firmware file in default search paths.

>         /* fall back on userspace loading */
>         buf->fmt = PAGE_BUF;
>


Thanks,
-- 
Ming Lei
