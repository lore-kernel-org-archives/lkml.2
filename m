Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802Ab0FNJWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:22:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56323 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab0FNJWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:22:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ghCPCiJpCg7mD5NlgrEkvA4Ej52CX5EqEThP539DfPiUfYgk77MEqWlEmOOnC6DcGB
         /8b1GtZ/82olFSFqIQD4Bf1u7Wf++rmhB2uC3DBGsnFjKPahBuMY33JSmuCob8Y1Ufcf
         vlFFWL/f5EwdnEVzxxXmBzxfwaMk8/s7rNX4g=
Message-ID: <4C15F4B7.5040601@gmail.com>
Date: Mon, 14 Jun 2010 11:21:59 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1rc2-2.2 Thunderbird/3.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-10-git-send-email-tj@kernel.org>
In-Reply-To: <1276443098-20653-10-git-send-email-tj@kernel.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2010 05:31 PM, Tejun Heo wrote:
> --- a/kernel/irq/spurious.c
> +++ b/kernel/irq/spurious.c
...

> @@ -25,9 +26,43 @@ enum {
>  	/* IRQ polling common parameters */
>  	IRQ_POLL_SLOW_INTV		= 3 * HZ,	/* not too slow for ppl, slow enough for machine */
>  	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
> +	IRQ_POLL_QUICK_INTV		= HZ / 1000,	/* pretty quick but not too taxing */
>  
>  	IRQ_POLL_SLOW_SLACK		= HZ,
>  	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
> +	IRQ_POLL_QUICK_SLACK		= HZ / 10000,	/* 10% slack */

Hi. These are zeros on most systems (assuming distros set HZ=100 and
250), what is their purpose then?

regards,
-- 
js
