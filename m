Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab2LCJrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:47:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48665 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2LCJrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:47:03 -0500
Message-ID: <50BC7513.5010504@canonical.com>
Date: Mon, 03 Dec 2012 10:46:59 +0100
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 12/37] ALSA: hda - Cirrus: Correctly clear line_out_pins when
 moving to speaker
References: <20121130183857.166228045@linuxfoundation.org> <20121130183858.536342330@linuxfoundation.org>
In-Reply-To: <20121130183858.536342330@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2012 07:45 PM, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: David Henningsson <david.henningsson@canonical.com>
>
> commit 34c3d1926bdaf45d3a891dd577482abcdd9faa34 upstream.
>
> If this array is not cleared, the jack related code later might
> fail to create "Internal Speaker Phantom Jack" on Dell Inspiron 3420 and
> Dell Vostro 2420.
>
> BugLink: https://bugs.launchpad.net/bugs/1076840
> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   sound/pci/hda/patch_cirrus.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- a/sound/pci/hda/patch_cirrus.c
> +++ b/sound/pci/hda/patch_cirrus.c
> @@ -413,6 +413,7 @@ static int parse_output(struct hda_codec
>   		memcpy(cfg->speaker_pins, cfg->line_out_pins,
>   		       sizeof(cfg->speaker_pins));
>   		cfg->line_outs = 0;
> +		memset(cfg->line_out_pins, 0, sizeof(cfg->line_out_pins));
>   	}
>
>   	return 0;
>
>

This one was originally targeted for 3.6+ (as mentioned in my original 
patch), for earlier kernels I don't anticipate it having any effect, 
neither positive nor negative. Your call.


-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
