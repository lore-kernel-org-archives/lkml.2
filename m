Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192Ab0JLJ4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:56:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46933 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757024Ab0JLJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:56:08 -0400
Date: Tue, 12 Oct 2010 10:56:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Dan Carpenter <error27@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ASoC: soc: snprintf() doesn't return negative
Message-ID: <20101012095605.GC30933@rakim.wolfsonmicro.main>
References: <20101011035416.GD5851@bicker>
 <20101011104009.GB9231@rakim.wolfsonmicro.main>
 <20101011164038.GE5851@bicker>
 <20101011185148.GB22355@opensource.wolfsonmicro.com>
 <20101011194502.GK5851@bicker>
 <s5hpqvg1m7v.wl%tiwai@suse.de>
 <20101012093506.GB30933@rakim.wolfsonmicro.main>
 <s5hvd57eo60.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hvd57eo60.wl%tiwai@suse.de>
X-Cookie: Words must be weighed, not counted.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 11:49:27AM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> Argh, yes, I'm (again) confused by that behavior.
> The problem is the potential buffer overflow, indeed.  snprintf()
> returns the size that would be printed.  Thus a safe code would be
> like:
> 
> 	list_for_each_entry(dai, &dai_list, list) {
>  		int len = snprintf(buf + ret, PAGE_SIZE - ret, "%s\n", dai->name);
>  		if (len < 0)
>  			continue;
>  		ret += len;
> 		if (ret >= PAGE_SIZE) {
> 			ret = PAGE_SIZE;
> 			break;
> 		}
> 	}

Yes, this form is better for that variant of the loop - that is safe and
legible without relying on current implementation details of snprintf().
