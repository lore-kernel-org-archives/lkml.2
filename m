Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab0JKTpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:45:23 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40221 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab0JKTpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kyaY9b/t3Loy5eiTpTJRVGGYMClv1O6rXDC7Tfd1704pEZmi7OPj6mZXTDJkOXaqT9
         QxAPj7QJ+m38NnhMDhWKVTabmqkxJwlIxQ3EzvyQ9gV4vlr53QGFcKTuYUculS8/u3ym
         zMZ7Bm3ToDhlSK/w+Pq4smwjjI4EdqlPX8eOU=
Date: Mon, 11 Oct 2010 21:45:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ASoC: soc: snprintf() doesn't return negative
Message-ID: <20101011194502.GK5851@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20101011035416.GD5851@bicker> <20101011104009.GB9231@rakim.wolfsonmicro.main> <20101011164038.GE5851@bicker> <20101011185148.GB22355@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101011185148.GB22355@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 07:51:48PM +0100, Mark Brown wrote:
> In actual fact quite a few devices have enough registers to be
> truncated, meaning that it's not only possible but likely we'll exercise
> the cases that deal with the end of buffer.  If snprintf() is returning
> values larger than buffer size it was given we're likely to have an
> issue but it seems that there's something missing in your analysis since
> we're never seeing WARN_ON()s and are instead seeing the behaviour the
> code is intended to give, which is to truncate the output when we run
> out of space.
> 
> Could you re-check your analysis, please?

That's odd.  I'm sorry, I can't explain why you wouldn't see a stack
trace...  The code is straight forward:

        /* Reject out-of-range values early.  Large positive sizes are
           used for unknown buffer sizes. */
        if (WARN_ON_ONCE((int) size < 0))
                return 0;

It would still give you truncated output but after the NULL terminator
there would be information leaked from the kernel.  If the reader
program had allocated a large enough buffer to handle the extra
information it wouldn't cause a problem.

regards,
dan carpenter


