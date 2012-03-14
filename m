Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2CNHM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 03:12:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40928 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2CNHMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 03:12:21 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203132258160.5229@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203132258160.5229@chino.kir.corp.google.com>
Date: Wed, 14 Mar 2012 08:12:19 +0100
Message-ID: <CAHR064gzke5o4C8cg2qH1d4VuXTMmqV-sAaiOv5O650qjc01sw@mail.gmail.com>
Subject: Re: [patch -next 1/2] drivers, samsung-laptop: fix initialization of
 sabi_data in sabi_set_commandb
From: Corentin Chary <corentin.chary@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 6:59 AM, David Rientjes <rientjes@google.com> wrote:
> Fields d0, d1, d2, and d3 are members of an anonymous struct inside an
> anonymous union inside struct sabi_data.  Initialization must be done by
> wrapping the anonymous union and structs with brackets to avoid a build
> error:
>
> drivers/platform/x86/samsung-laptop.c: In function ‘sabi_set_commandb’:
> drivers/platform/x86/samsung-laptop.c:433: error: unknown field ‘d0’ specified in initializer
> drivers/platform/x86/samsung-laptop.c:433: warning: missing braces around initializer
> drivers/platform/x86/samsung-laptop.c:433: warning: (near initialization for ‘in.<anonymous>’)
> ...
>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  drivers/platform/x86/samsung-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -430,7 +430,7 @@ exit:
>  static int sabi_set_commandb(struct samsung_laptop *samsung,
>                             u16 command, u8 data)
>  {
> -       struct sabi_data in = { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 };
> +       struct sabi_data in = { { { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 } } };
>
>        in.data[0] = data;
>        return sabi_command(samsung, command, &in, NULL);


Acked-by: Corentin Chary <corentincj@iksaif.net>

David, just in case, I found this mail in my spam folder, probably
because your smtp server is not allowed to send @google.com mails.

Also, with which version of gcc is this necessary ? Old version worked
with 4.5 and 4.6.

Matthew, could you merge that one and the other directly in your tree ? Thanks
-- 
Corentin Chary
http://xf.iksaif.net
