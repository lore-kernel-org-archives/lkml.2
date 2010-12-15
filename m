Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab0LOOtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 09:49:17 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:48473 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0LOOtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:49:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=jFnnXZxloRl0WLNmxbCSZejISG3SSFlJyG6bswqX+uSzm5lkbrqqpKmgEyWzEPW7kM
         wCl5LjKUmnrLQTQ4rE9m5xsVr+6ITv7ElbA41uWawYyqukCthADrr1NsmN/dMJGA+bjg
         g+/ld64B3gDWAZCr+D8w0oerj5X1lWFw3Sf+s=
Message-ID: <4D08D568.5040801@gmail.com>
Date: Wed, 15 Dec 2010 15:49:12 +0100
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: Re: [patch 2/3] add new macros to make percpu readmostly section
 correctly align
References: <1291255347.12777.116.camel@sli10-conroe> <4D0243DD.3090507@gmail.com> <1292200886.2323.15.camel@sli10-conroe> <4D05EBA4.60202@gmail.com> <1292288924.2323.458.camel@sli10-conroe> <4D073FA9.9020801@gmail.com> <1292378268.2323.464.camel@sli10-conroe> <4D08CBF4.6040102@gmail.com>
In-Reply-To: <4D08CBF4.6040102@gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/15/2010 03:08 PM, Tejun Heo wrote:
>> +#ifdef INTERNODE_CACHE_BYTES
>> +#define INTERNODE_CACHEALIGNED						\
>> +	. = ALIGN(INTERNODE_CACHE_BYTES);
>> +#else
>> +#define INTERNODE_CACHEALIGNED
>> +#endif
> 
> Yeah, this looks good.

Just one more thing.  If you look at various arch linker scripts,
cache line size is always present.  After all, RW_DATA_SECTION() needs
it.  They're different define's or sometimes hardcoded values but it
would be nice if we can take this chance to unify them and use it for
this too.  Would you be interested in doing that?

Thanks.

-- 
tejun
