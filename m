Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab2GYQ5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:57:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57028 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab2GYQ53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:57:29 -0400
Message-ID: <50102563.8090909@zytor.com>
Date: Wed, 25 Jul 2012 09:57:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Yinghai Lu <yinghai@kernel.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: simplify mtrr_bp_init()
References: <4FF70FDB020000780008E199@nat28.tlf.novell.com> <CAE9FiQUkt7s_zfbn+iZcKXaRpvOHm9CWjxvqpNsLsnSywdHoug@mail.gmail.com> <500FC39702000078000905AD@nat28.tlf.novell.com>
In-Reply-To: <500FC39702000078000905AD@nat28.tlf.novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 12:59 AM, Jan Beulich wrote:
>>
>> should drop all phys_addr assignment in this function.
>>
>> x86_phys_bits should have all correct value?
>
> Is it certain that all special cases (setting phys_addr to 32) are
> covered by those CPUs not having PAE/PSE36? One would
> think that this is valid to imply, but getting cpu_info's phys_bits
> wrong isn't fatal as long as no addresses beyond 4G would ever
> be encountered anywhere, whereas using too large an address
> width here would result in the MTRR writes causing #GP. So
> when I did this adjustment (a couple of years ago already - this
> isn't the first submission), I decided to remain on the safe side.
>
> Does any of the maintainers have an opinion either way?
>

There are definitely CPUs which have PAE but only has a 32-bit address 
bus.  On the other hand there are tons of chipsets which arbitrary 
address caps that almost nothing in the system knows about, so I don't 
think this matters.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

