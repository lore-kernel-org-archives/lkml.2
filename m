Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab0JZXZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 19:25:04 -0400
Received: from redmars.org ([92.243.31.175]:49942 "EHLO deckard.alcopop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758225Ab0JZXZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 19:25:02 -0400
Date: Wed, 27 Oct 2010 00:24:59 +0100
From: Jon Dowland <jmtd@debian.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] toshiba_acpi.c: Add key_entry for a lone FN keypress
Message-ID: <20101026232459.GA1444@deckard.alcopop.org>
References: <20101023221253.GA4829@hathor> <201010251127.37374.dmitry.torokhov@gmail.com> <20101026120026.GA27720@deckard.alcopop.org> <20101026155653.GC13097@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101026155653.GC13097@core.coreip.homeip.net>
X-Challenge-Response: refused
X-Forelli-filterword: GO1268Op
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 08:56:53AM -0700, Dmitry Torokhov wrote:
> > Add a key entry to map this event to a KEY_UNKNOWN keypress silences
> 
>                                          ^^^^^^
> Better fix commit log message as well. Otherwise:
> 
> 	Acked-by: Dmitry Torokhov <dtor@mail.ru>

Thanks.

Signed-off-by: Jon Dowland <jmtd@debian.org>

----

A lone FN key press on a Toshiba Portégé R700 without another key in
conjunction results in an ACPI event and a spurious error message on
the console.

Add a key entry to map this event to a KEY_FN keypress. This prevents
the console message.

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 06f304f..e10747a 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -135,6 +135,7 @@ static const struct key_entry toshiba_acpi_keymap[] __initconst = {
 	{ KE_KEY, 0x141, { KEY_BRIGHTNESSUP } },
 	{ KE_KEY, 0x142, { KEY_WLAN } },
 	{ KE_KEY, 0x143, { KEY_PROG1 } },
+	{ KE_KEY, 0x17f, { KEY_FN } },                                          
 	{ KE_KEY, 0xb05, { KEY_PROG2 } },
 	{ KE_KEY, 0xb06, { KEY_WWW } },
 	{ KE_KEY, 0xb07, { KEY_MAIL } },
