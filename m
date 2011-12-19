Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1LSXZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:25:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49072 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1LSXZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:25:33 -0500
Message-ID: <4EEFC7D2.70803@zytor.com>
Date: Mon, 19 Dec 2011 15:25:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, trenn@suse.de, kay.sievers@vrf.org,
        Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org, axboe@kernel.dk,
        herbert@gondor.hengli.com.au, ying.huang@intel.com
Subject: Re: [PATCH 03/10] crypto: Add support for x86 cpuid auto loading
 for x86 crypto drivers
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org> <1324334865-30459-4-git-send-email-andi@firstfloor.org> <20111219232246.GB570@redhat.com>
In-Reply-To: <20111219232246.GB570@redhat.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 03:22 PM, Dave Jones wrote:
> On Mon, Dec 19, 2011 at 02:47:39PM -0800, Andi Kleen wrote:
> 
>  >  static int __init padlock_init(void)
>  >  {
>  >  	int rc = -ENODEV;
>  > @@ -533,15 +540,8 @@ static int __init padlock_init(void)
>  >  	struct shash_alg *sha1;
>  >  	struct shash_alg *sha256;
>  >  
>  > -	if (!cpu_has_phe) {
>  > -		printk(KERN_NOTICE PFX "VIA PadLock Hash Engine not detected.\n");
>  > -		return -ENODEV;
>  > -	}
>  > -
>  > -	if (!cpu_has_phe_enabled) {
>  > -		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
>  > +	if (!x86_match_cpu(padlock_sha_ids) || !cpu_has_phe_enabled)
>  >  		return -ENODEV;
>  > -	}
> 
> don't we want to keep the printk ?
> 
> Seems that if it's been disabled by the BIOS for some reason, it will now
> silently fail instead of printing a nice warning.
> 

The first printk is insanely annoying, because the end result is that we
get a printk of all the crypto engines that are *not* enabled...
arguably it would be somewhat nice to get a printk when a crypto engine
*is* enabled.

	-hpa

