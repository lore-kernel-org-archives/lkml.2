Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0GZQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:09:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50624 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0GZQJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:09:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=H+XhHacwZvfZ5JqeNh2OkgXwZOAyDtjuCcdnwiruNp6l9upv6yUNdIJ/j0dAiHxv9j
         DbeeUOKmOxmt2oebW1i37i0JcbkYTLUZHHlLcYtJHdlmhX7PGeQep2YSSpQBEwdgoP7S
         GVXAmU7mkY/Hojs+EchijKagmMG1JV3MbAYBs=
Message-ID: <4C4DB34E.9060702@gmail.com>
Date: Mon, 26 Jul 2010 18:09:50 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        fengguang.wu@intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: hda_intel: too quiet sound (regression)
References: <4C4D9EDA.3060505@gmail.com> <s5htynmuvw4.wl%tiwai@suse.de>
In-Reply-To: <s5htynmuvw4.wl%tiwai@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 05:04 PM, Takashi Iwai wrote:
> Looks like a regression by the amp max value check.
> The following patch should fix the problem.

Works for me.

> ---
> From 7ccc3eface57b6e1773fce009dac8a3da081b8b1 Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Mon, 26 Jul 2010 17:00:15 +0200
> Subject: [PATCH] ALSA: hda - Fix max amp cap calculation for IDT/STAC codecs
> 
> The commit afbd9b8448f4b7d15673c6858012f384f18d28b8
>     ALSA: hda - Limit the amp value to write
> introduced a regression for codec setups with amp offsets like IDT/STAC
> codecs.  The limit value should be a raw value without offset calculation.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Tested-by: Jiri Slaby <jirislaby@gmail.com>

thanks,
-- 
js
