Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab1DLStf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 14:49:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61683 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1DLSte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 14:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Cs4DOo1leSkBF+v6cpUBiewVY+nopNXACHNr1p7/hcSQLW0U+WJV/V9i1mImgYz/yo
         qGamVeOcvAlpNCNFp7rGolSuT0XuG+RC3PECMNV9rdzsfbO2aMq5QiI6qVier7uCJ2iC
         Y0qHCHD6UbHjyjb3NpTg9fPImDHN7+SqQOOSA=
Date: Wed, 13 Apr 2011 03:49:27 +0900
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cl@linux.com
Subject: Re: [PATCH 1/4]percpu_counter: make API return consistent value
Message-ID: <20110412184927.GB16342@mtj.dyndns.org>
References: <1302595437.3981.127.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302595437.3981.127.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

First of all, please somehow link patches of the same series.  Either
write a head message and make all the patches replies to it
(preferred) or chain reply the patches (only when the number of
patches is small).

On Tue, Apr 12, 2011 at 04:03:57PM +0800, Shaohua Li wrote:
> the percpu_counter_*_positive() API SMP and !SMP aren't consistent. From
> the API name, we should return a non-negative value for them.
> Also if count < 0, returns 0 instead of 1 for *read_positive().

Ummm, on UP, the counters cannot be positive.  The _positive interface
is there to make it easier to cope with deviations introduced by
unsynchronized modifications by different CPUs.  On UP, such
deviations don't happen at all so _positive interface is the same as
the counterpart without the postfix.

Thanks.

-- 
tejun
