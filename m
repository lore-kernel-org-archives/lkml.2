Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1GYBTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 21:19:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:58972 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1GYBTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 21:19:34 -0400
MIME-Version: 1.0
In-Reply-To: <1311268581-20405-2-git-send-email-lacombar@gmail.com>
References: <1311268581-20405-1-git-send-email-lacombar@gmail.com>
	<1311268581-20405-2-git-send-email-lacombar@gmail.com>
Date: Sun, 24 Jul 2011 21:19:34 -0400
Message-ID: <CACqU3MVY6n5HXAqUXaOEjs_z=Q9G2PSGnCWHWkstZ0PZWjpoZA@mail.gmail.com>
Subject: Re: [PATCH 2/4] drivers/base/devtmpfs.c: correct annotation of `setup_done'
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I saw that devtmpfs stuff went on through Al Viro's tree, maybe I
should have Cc: him on this ?

Thanks,
 - Arnaud

On Thu, Jul 21, 2011 at 1:16 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> This fixes the following section mismatch issue:
>
> WARNING: vmlinux.o(.text+0x1192bf): Section mismatch in reference from the function devtmpfsd() to the variable .init.data:setup_done
> The function devtmpfsd() references the variable __initdata setup_done.
> This is often because devtmpfsd lacks a __initdata annotation or the annotation of setup_done is wrong.
>
> WARNING: vmlinux.o(.text+0x119342): Section mismatch in reference from the function devtmpfsd() to the variable .init.data:setup_done
> The function devtmpfsd() references the variable __initdata setup_done.
> This is often because devtmpfsd lacks a __initdata annotation or the annotation of setup_done is wrong.
>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  drivers/base/devtmpfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
> index 6d678c9..38e6464 100644
> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -376,7 +376,7 @@ int devtmpfs_mount(const char *mntdir)
>        return err;
>  }
>
> -static __initdata DECLARE_COMPLETION(setup_done);
> +static DECLARE_COMPLETION(setup_done);
>
>  static int handle(const char *name, mode_t mode, struct device *dev)
>  {
> --
> 1.7.6.153.g78432
>
>
