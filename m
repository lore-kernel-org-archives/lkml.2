Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1DLTDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 15:03:12 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61126 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab1DLTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 15:02:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hD1cNhdBJJ8yF+a5P+kRw2GMtrErTo1qRkNwGVqtDcsH8mByo7WlIlf3JUgV7BQLHh
         5ld6R70WfudPo6JqfVAap+Wzg8mty1QrhGO6yXXylycCVXwaljP9bqZEwuRgTGWlkGrf
         EXKkRCcO2SuHziRXO/Zv03JiRx+G/1dSnQSXs=
Date: Wed, 13 Apr 2011 04:02:51 +0900
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cl@linux.com
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
Message-ID: <20110412190251.GD16342@mtj.dyndns.org>
References: <1302595444.3981.129.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302595444.3981.129.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 04:04:04PM +0800, Shaohua Li wrote:
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>  {
> +#if BITS_PER_LONG == 32
> +	s64 count;
> +	spin_lock(&fbc->lock);
> +	count = fbc->count;
> +	spin_unlock(&fbc->lock);
> +	return count;
> +#else
>  	return fbc->count;
> +#endif

I don't know.  Is there any problem caused by this?  The interface is
known to be unreliable and already being used in speculative manner.
I think it's more beneficial to avoid using locks on fast read path.

Thanks.

-- 
tejun
