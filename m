Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab0ESMGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 08:06:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38514 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188Ab0ESMGv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 08:06:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YdiIkROP3XPFWpq10gFyZVUgiWu8gRLkSPYl1d0XM5jbTvONZ8PRZK9jJPNB/hokZF
         JlHKBH6P9UwlWxFXUeyBR9VppesiJZUvl0GCnZwsGdfWNliGdqAAM9AuTHvkv6Vd75Qs
         8icTHYmZ1i1xxyZEHwTe4m68Ioxfo4JRrEPOI=
MIME-Version: 1.0
In-Reply-To: <1274265421-26747-1-git-send-email-daniel@caiaq.de>
References: <1274265421-26747-1-git-send-email-daniel@caiaq.de>
Date: Wed, 19 May 2010 14:06:46 +0200
Message-ID: <AANLkTimTjuQUEulo8g7clpECJVHwwDc29nkWskw6fWF-@mail.gmail.com>
Subject: Re: [PATCH] drivers/platform/x86/eeepc-wmi.c: fix build warning
From: Corentin Chary <corentin.chary@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
       Yong Wang <yong.y.wang@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
       Tejun Heo <tj@kernel.org>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 12:37 PM, Daniel Mack <daniel@caiaq.de> wrote:
> drivers/platform/x86/eeepc-wmi.c: In function ‘eeepc_wmi_notify’:
> drivers/platform/x86/eeepc-wmi.c:209: warning: ‘new’ may be used uninitialized in this function
> drivers/platform/x86/eeepc-wmi.c:209: note: ‘new’ was declared here
>
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Yong Wang <yong.y.wang@intel.com>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: platform-driver-x86@vger.kernel.org
> ---
>  drivers/platform/x86/eeepc-wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
> index b227eb4..9dc50fb 100644
> --- a/drivers/platform/x86/eeepc-wmi.c
> +++ b/drivers/platform/x86/eeepc-wmi.c
> @@ -206,7 +206,7 @@ static int eeepc_wmi_backlight_notify(struct eeepc_wmi *eeepc, int code)
>  {
>        struct backlight_device *bd = eeepc->backlight_device;
>        int old = bd->props.brightness;
> -       int new;
> +       int new = old;
>
>        if (code >= NOTIFY_BRNUP_MIN && code <= NOTIFY_BRNUP_MAX)
>                new = code - NOTIFY_BRNUP_MIN + 1;
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Acked-By: Corentin Chary <corentincj@iksaif.net>

-- 
Corentin Chary
http://xf.iksaif.net
