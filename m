Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0JLKkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 06:40:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43353 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab0JLKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 06:40:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=lYV1jD4xlep4ceFjWVWvuDc+W5HcH1wSTbCWszW7YKFKfx0v6Jjhov2WneOayh3Z1C
         FJ9lCgZudbnhOOtZazorJiYwDXaPhhtjF1HONdj/MY/hmz3RdI6IQuYsUgyeVI14wtwq
         jGoT7VgzcELQcCnmcCvhj8qpIMmn6d2kkUd28=
Date: Tue, 12 Oct 2010 12:40:22 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ASoC: soc: snprintf() doesn't return negative
Message-ID: <20101012104022.GA6742@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
	Jaroslav Kysela <perex@perex.cz>,
	Peter Ujfalusi <peter.ujfalusi@nokia.com>,
	Jassi Brar <jassi.brar@samsung.com>, alsa-devel@alsa-project.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20101011035416.GD5851@bicker> <20101011104009.GB9231@rakim.wolfsonmicro.main> <20101011164038.GE5851@bicker> <20101011185148.GB22355@opensource.wolfsonmicro.com> <20101011194502.GK5851@bicker> <s5hpqvg1m7v.wl%tiwai@suse.de> <20101012093506.GB30933@rakim.wolfsonmicro.main> <s5hvd57eo60.wl%tiwai@suse.de> <20101012095605.GC30933@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012095605.GC30933@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 10:56:05AM +0100, Mark Brown wrote:
> On Tue, Oct 12, 2010 at 11:49:27AM +0200, Takashi Iwai wrote:
> > Mark Brown wrote:
> 
> > Argh, yes, I'm (again) confused by that behavior.
> > The problem is the potential buffer overflow, indeed.  snprintf()
> > returns the size that would be printed.  Thus a safe code would be
> > like:
> > 
> > 	list_for_each_entry(dai, &dai_list, list) {
> >  		int len = snprintf(buf + ret, PAGE_SIZE - ret, "%s\n", dai->name);
> >  		if (len < 0)
> >  			continue;
> >  		ret += len;
> > 		if (ret >= PAGE_SIZE) {
> > 			ret = PAGE_SIZE;
> > 			break;
> > 		}
> > 	}
> 
> Yes, this form is better for that variant of the loop - that is safe and
> legible without relying on current implementation details of snprintf().

This is fine with me as well.  My original patch had a problem with the
WARN_ON() so your version is better.

regards,
dan carpenter

