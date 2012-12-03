Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab2LCU4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:56:51 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:37060 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab2LCU4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:56:49 -0500
Date: Mon, 3 Dec 2012 12:56:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Henningsson <david.henningsson@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 12/37] ALSA: hda - Cirrus: Correctly clear line_out_pins when
 moving to speaker
Message-ID: <20121203205645.GA32037@kroah.com>
References: <20121130183857.166228045@linuxfoundation.org>
 <20121130183858.536342330@linuxfoundation.org>
 <50BC7513.5010504@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50BC7513.5010504@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:46:59AM +0100, David Henningsson wrote:
> On 11/30/2012 07:45 PM, Greg Kroah-Hartman wrote:
> >3.0-stable review patch.  If anyone has any objections, please let me know.
> >
> >------------------
> >
> >From: David Henningsson <david.henningsson@canonical.com>
> >
> >commit 34c3d1926bdaf45d3a891dd577482abcdd9faa34 upstream.
> >
> >If this array is not cleared, the jack related code later might
> >fail to create "Internal Speaker Phantom Jack" on Dell Inspiron 3420 and
> >Dell Vostro 2420.
> >
> >BugLink: https://bugs.launchpad.net/bugs/1076840
> >Signed-off-by: David Henningsson <david.henningsson@canonical.com>
> >Signed-off-by: Takashi Iwai <tiwai@suse.de>
> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> >---
> >  sound/pci/hda/patch_cirrus.c |    1 +
> >  1 file changed, 1 insertion(+)
> >
> >--- a/sound/pci/hda/patch_cirrus.c
> >+++ b/sound/pci/hda/patch_cirrus.c
> >@@ -413,6 +413,7 @@ static int parse_output(struct hda_codec
> >  		memcpy(cfg->speaker_pins, cfg->line_out_pins,
> >  		       sizeof(cfg->speaker_pins));
> >  		cfg->line_outs = 0;
> >+		memset(cfg->line_out_pins, 0, sizeof(cfg->line_out_pins));
> >  	}
> >
> >  	return 0;
> >
> >
> 
> This one was originally targeted for 3.6+ (as mentioned in my
> original patch), for earlier kernels I don't anticipate it having
> any effect, neither positive nor negative. Your call.

Ah, I messed up on that, sorry, I've dropped it from the 3.0-stable
queue now.

greg k-h
