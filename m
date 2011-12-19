Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1LSXXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:23:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab1LSXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:23:17 -0500
Date: Mon, 19 Dec 2011 18:22:46 -0500
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, trenn@suse.de,
        kay.sievers@vrf.org, Andi Kleen <ak@linux.intel.com>,
        kay.sievers@vrfy.org, axboe@kernel.dk, herbert@gondor.hengli.com.au,
        ying.huang@intel.com
Subject: Re: [PATCH 03/10] crypto: Add support for x86 cpuid auto loading for
 x86 crypto drivers
Message-ID: <20111219232246.GB570@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	hpa@zytor.com, trenn@suse.de, kay.sievers@vrf.org,
	Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org,
	axboe@kernel.dk, herbert@gondor.hengli.com.au, ying.huang@intel.com
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org>
 <1324334865-30459-4-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324334865-30459-4-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:47:39PM -0800, Andi Kleen wrote:

 >  static int __init padlock_init(void)
 >  {
 >  	int rc = -ENODEV;
 > @@ -533,15 +540,8 @@ static int __init padlock_init(void)
 >  	struct shash_alg *sha1;
 >  	struct shash_alg *sha256;
 >  
 > -	if (!cpu_has_phe) {
 > -		printk(KERN_NOTICE PFX "VIA PadLock Hash Engine not detected.\n");
 > -		return -ENODEV;
 > -	}
 > -
 > -	if (!cpu_has_phe_enabled) {
 > -		printk(KERN_NOTICE PFX "VIA PadLock detected, but not enabled. Hmm, strange...\n");
 > +	if (!x86_match_cpu(padlock_sha_ids) || !cpu_has_phe_enabled)
 >  		return -ENODEV;
 > -	}

don't we want to keep the printk ?

Seems that if it's been disabled by the BIOS for some reason, it will now
silently fail instead of printing a nice warning.

	Dave

