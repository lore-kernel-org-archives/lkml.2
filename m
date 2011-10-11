Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1JKKLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 06:11:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59637 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab1JKKLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 06:11:31 -0400
MIME-Version: 1.0
X-Originating-IP: [136.163.44.102]
In-Reply-To: <1314728964-20863-1-git-send-email-iceaway@gmail.com>
References: <1314728964-20863-1-git-send-email-iceaway@gmail.com>
Date: Tue, 11 Oct 2011 12:11:31 +0200
Message-ID: <CAOdCkm2mtU8v4YrU2-r2aRJOFKruk0mWUV9T67gheykM=74DfQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging: panel: Fixed checkpatch warning about simple_strtoul()
From: Pelle Windestam <pelle@windestam.se>
To: Pelle Windestam <iceaway@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 8:29 PM, Pelle Windestam <iceaway@gmail.com> wrote:
> Fixed the checkpatch warning about sing simple_strtoul instead of
> kstrtoul() in panel.c.
>
> Signed-off-by: Pelle Windestam <iceaway@gmail.com>
> ---
>  drivers/staging/panel/panel.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> index b303b7e..4683d5f 100644
> --- a/drivers/staging/panel/panel.c
> +++ b/drivers/staging/panel/panel.c
> @@ -1179,16 +1179,14 @@ static inline int handle_lcd_special_code(void)
>                        break;
>
>                while (*esc) {
> -                       char *endp;
> -
>                        if (*esc == 'x') {
>                                esc++;
> -                               lcd_addr_x = simple_strtoul(esc, &endp, 10);
> -                               esc = endp;
> +                               if (kstrtoul(esc, 10, &lcd_addr_x) < 0)
> +                                       break;
>                        } else if (*esc == 'y') {
>                                esc++;
> -                               lcd_addr_y = simple_strtoul(esc, &endp, 10);
> -                               esc = endp;
> +                               if (kstrtoul(esc, 10, &lcd_addr_y) < 0)
> +                                       break;
>                        } else
>                                break;
>                }
> --
> 1.7.3.4
>
>

Was there any reason for not accepting this patch?

//Pelle
