Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab2CCHzD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 02:55:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab2CCHzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 02:55:01 -0500
Date: Sat, 3 Mar 2012 08:54:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] x86, efi: fix pointer math issue in handle_ramdisks()
Message-ID: <20120303075443.GC16816@elte.hu>
References: <20120302190128.GC3951@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302190128.GC3951@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Carpenter <dan.carpenter@oracle.com> wrote:

> "filename" is a efi_char16_t string so this check for reaching 
> the end of the array doesn't work.  We need to cast it to char 
> pointer before doing the math.

That name should really be changed, 'filename' is a char * by 
convention pretty much everywhere in the kernel - so the current 
naming is highly misleading and results in bugs like this.

filename_16, filename_2byte or filename_UTF or so would be 
suggestive enough to avoid such mishaps in the future.

> @@ -559,7 +559,7 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
>  			str++;
>  
>  		while (*str && *str != ' ' && *str != '\n') {
> -			if (p >= filename + sizeof(filename))
> +			if ((char *)p >= (char *)filename + sizeof(filename))
>  				break;

I'd also make that void *, because this isnt really a C 
character string anymore.

Thanks,

	Ingo
