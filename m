Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0G1VVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:21:11 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41018 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0G1VVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:21:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=d11Y5ojYSnYtyY7RXwEM4MR7FjPsLm4YjqLrVosG9ABE9uAaX6JMb56HUhp6N+ScPM
         ZL/KXex1fqfG88bPJC3MtfCmYhYzVcQEUgjW6sal77dGlOFZjWsWLi07jUIktV9/liGD
         OczOo+4kQLqZWGmhSjo5yO6bsbWWkM4X/wWEI=
Date: Wed, 28 Jul 2010 23:20:31 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Andrew Veliath <andrewtv@usa.net>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] oss: msnd: check request_region() return value
Message-ID: <20100728212031.GQ26313@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	kernel-janitors@vger.kernel.org, Andrew Veliath <andrewtv@usa.net>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
	Arnd Bergmann <arnd@arndb.de>, Tejun Heo <tj@kernel.org>,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1280335296-23475-1-git-send-email-segooon@gmail.com> <20100728200002.GP26313@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728200002.GP26313@bicker>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 10:00:02PM +0200, Dan Carpenter wrote:
> This should be -EBUSY as well.  The same for "[PATCH 06/10] ALSA: msnd: 
> check request_region() return value"
> 
> Another way to write that would be:
> 

Gar.  I was thinking of request_resource().  request_region() returns a
pointer of course.

But still the return code should probably be -EBUSY.  Resource
conflicts are more likely than allocation failures.

regards,
dan carpenter

> -	request_region(dev.io, dev.numio, dev.name);
> +	err = request_region(dev.io, dev.numio, dev.name);
> +	if (err) {
> +		free_irq(dev.irq, &dev);
> +		return err;
> +	}
> 
> regards,
> dan carpenter
> 
> > +	if (request_region(dev.io, dev.numio, dev.name) == NULL) {
> > +		free_irq(dev.irq, &dev);
> > +		return -ENOMEM;
> > +	}
