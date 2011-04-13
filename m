Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab1DMDIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 23:08:39 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65132 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab1DMDIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 23:08:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rVOBRgtV+tA4pUORSgYsbwl4k/B9m3zIt5P4vYIwv5+lPRUOI7pJwwPHk2HrNHJpC0
         Sm2MinXPR2Xhm7+vzUGjt1/X1dKWH3Tg6LsgXEhCzJytLxEfW+ZUiAJqx+WkkEw5sflu
         aJmjHHNa72FOYChqq7BcXliMkv0ZVexhlJ6wU=
Date: Wed, 13 Apr 2011 12:08:31 +0900
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
Subject: Re: [PATCH 1/4]percpu_counter: make API return consistent value
Message-ID: <20110413030831.GG16342@mtj.dyndns.org>
References: <1302595437.3981.127.camel@sli10-conroe>
 <20110412184927.GB16342@mtj.dyndns.org>
 <1302657855.3981.153.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302657855.3981.153.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Apr 13, 2011 at 09:24:15AM +0800, Shaohua Li wrote:
> > Ummm, on UP, the counters cannot be positive.
> s/positive/negative?

Yeap.

> >   The _positive interface
> > is there to make it easier to cope with deviations introduced by
> > unsynchronized modifications by different CPUs.  On UP, such
> > deviations don't happen at all so _positive interface is the same as
> > the counterpart without the postfix.
> I'm confused. the counter could be negative, we have *_dec, *_sub.

Yes it can technically but I was referring to the intent of the API.
The whole percpu counter is supposed to track a positive number.  The
_positive interface is there just to cope with deviations caused by
distribution over multiple per-cpu counters, which can't happen on UP.
When the counter can actually be negative, the API doesn't make whole
lot of sense.  I agree it's poorly documented.

Thanks.

-- 
tejun
