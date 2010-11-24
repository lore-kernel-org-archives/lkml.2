Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0KXOoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:44:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44954 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751189Ab0KXOoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:44:37 -0500
Date: Wed, 24 Nov 2010 14:44:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        vbarinov@embeddedalley.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: tlv320aic3x - fix variable may be used
 uninitialized warning
Message-ID: <20101124144434.GI24970@rakim.wolfsonmicro.main>
References: <1290609659.2749.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290609659.2749.2.camel@phoenix>
X-Cookie: Made with real ingredients.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:40:59PM +0800, Axel Lin wrote:
> If aic3x_read failed , val is used uninitialized.
> Fix it by initializing val to 0.
> 
> This patch fixes below compile warning:
> sound/soc/codecs/tlv320aic3x.c: In function 'aic3x_get_gpio':
> sound/soc/codecs/tlv320aic3x.c:1183: warning: 'val' may be used uninitialized in this function
> sound/soc/codecs/tlv320aic3x.c: In function 'aic3x_headset_detected':
> sound/soc/codecs/tlv320aic3x.c:1211: warning: 'val' may be used uninitialized in this function
> sound/soc/codecs/tlv320aic3x.c: In function 'aic3x_button_pressed':
> sound/soc/codecs/tlv320aic3x.c:1219: warning: 'val' may be used uninitialized in this function

This does rather look like a compiler bug.  I'm generally against this
sort of change as it just tramples over the warning in cases where it
may be valid, though given the trivially small functions here it's hard
to care.

Really this stuff should all be written to use the standard jack and
GPIO APIs anyway.
