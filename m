Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1JVT3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 15:29:05 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61541 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1JVT3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 15:29:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1110221307010.59156@linux>
References: <alpine.LNX.2.00.1110221307010.59156@linux>
Date: Sat, 22 Oct 2011 15:29:01 -0400
Message-ID: <CACqU3MUmg6KN7MQe7T3j+D06m1R=4R+q6C5z-SCOnxCj=zZ5OA@mail.gmail.com>
Subject: Re: [PATCH] kbuild: silence moc when V=0
From: Arnaud Lacombe <lacombar@gmail.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Oct 22, 2011 at 1:10 PM, Peter Foley <pefoley2@verizon.net> wrote:
> Use quiet_cmd to silence moc when V=0
>
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
>
This was included in my branch reworking the checking logic in the
Makefile, I still need to find some time to finish to polish it.

 - Arnaud

> ---
>  scripts/kconfig/Makefile |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 1d99a08..7f1a6cd 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -322,8 +322,11 @@ $(obj)/zconf.tab.o: $(obj)/zconf.lex.c $(obj)/zconf.hash.c
>
>  $(obj)/qconf.o: $(obj)/qconf.moc
>
> -$(obj)/%.moc: $(src)/%.h
> -       $(KC_QT_MOC) -i $< -o $@
> +quiet_cmd_moc = MOC     $@
> +cmd_moc = $(KC_QT_MOC) -i $< -o $@
> +
> +$(obj)/qconf.moc: $(src)/qconf.h
> +       $(call if_changed,moc)
>
>  # Extract gconf menu items for I18N support
>  $(obj)/gconf.glade.h: $(obj)/gconf.glade
> --
> 1.7.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
