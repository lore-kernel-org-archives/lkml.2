Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2KVSkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:40:07 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59839 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754761Ab2KVSj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:39:58 -0500
MIME-Version: 1.0
In-Reply-To: <20121122021546.GA6076@shaftnet.org>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
	<CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
	<20121120161011.GD18015@shaftnet.org>
	<20121120163309.GB4990@kroah.com>
	<20121120181203.GA7922@shaftnet.org>
	<20121121093528.4fe11c26@tom-ThinkPad-T410>
	<20121121140109.GA7549@shaftnet.org>
	<CACVXFVOuGQTLKSuFmTnv50-Eo0hzZSA2gh65upWu-E+439Dvsg@mail.gmail.com>
	<20121122021546.GA6076@shaftnet.org>
Date: Thu, 22 Nov 2012 10:42:51 +0800
Message-ID: <CACVXFVPKaKqvuTKjHOVx9p8=-rpmAiSiWsxvvxzR2wn+Cf0ptw@mail.gmail.com>
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
From: Ming Lei <tom.leiming@gmail.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 10:15 AM, Solomon Peachy <pizza@shaftnet.org> wrote:
> On Thu, Nov 22, 2012 at 09:45:23AM +0800, Ming Lei wrote:
>> No, it is not related closely, CONFIG_FIRMWARE_IN_KERNEL means
>> that all in-kernel-tree firmware blobs should be included in kernel binary,
>> but CONFIG_EXTRA_FIRMARE means that one additional firmware
>> image will be put into kernel binary.
>
> Okay.
>
>> Considered that there is no your problem in -linus tree or -next tree
>> and the current code works for long time, maybe it is better to not
>> touch the code. Or suggest you to study this kind of config options
>> and firmware/Makefie first, then figure out one proper patch.
>
> Given what you've told me (i.e. support for loading "builtin" firmware is
> always required), I propose this patch instead:

Sorry, I didn't tell you builtin firmware is always required, :-(

>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 8945f4e..d291e15 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -38,8 +38,6 @@ MODULE_LICENSE("GPL");
>
>  /* Builtin firmware support */
>
> -#ifdef CONFIG_FW_LOADER
> -
>  extern struct builtin_fw __start_builtin_fw[];
>  extern struct builtin_fw __end_builtin_fw[];
>
> @@ -69,19 +67,6 @@ static bool fw_is_builtin_firmware(const struct firmware *fw)
>         return false;
>  }
>
> -#else /* Module case - no builtin firmware support */
> -
> -static inline bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
> -{
> -       return false;
> -}
> -
> -static inline bool fw_is_builtin_firmware(const struct firmware *fw)
> -{
> -       return false;
> -}
> -#endif
> -
>  enum {
>         FW_STATUS_LOADING,
>         FW_STATUS_DONE,
>
>
> The empty stub functions can never be compiled, as firmware_class.c
> isn't compiled when CONFIG_FW_LOADER isn't enabled.  So let's just nuke
> this unused code entirely.

But looks this patch is fine for me.


Thanks,
-- 
Ming Lei
