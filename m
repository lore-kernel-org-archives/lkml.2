Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab2GZHB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:01:56 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52879 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab2GZHBz convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 26 Jul 2012 03:01:55 -0400
Message-Id: <5011077F020000780009088F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 26 Jul 2012 08:01:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: <mingo@elte.hu>, "Yinghai Lu" <yinghai@kernel.org>, <tglx@linutronix.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: simplify mtrr_bp_init()
References: <4FF70FDB020000780008E199@nat28.tlf.novell.com>
 <CAE9FiQUkt7s_zfbn+iZcKXaRpvOHm9CWjxvqpNsLsnSywdHoug@mail.gmail.com>
 <500FC39702000078000905AD@nat28.tlf.novell.com>
 <50102563.8090909@zytor.com>
In-Reply-To: <50102563.8090909@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 25.07.12 at 18:57, "H. Peter Anvin" <hpa@zytor.com> wrote:
> On 07/25/2012 12:59 AM, Jan Beulich wrote:
>>>
>>> should drop all phys_addr assignment in this function.
>>>
>>> x86_phys_bits should have all correct value?
>>
>> Is it certain that all special cases (setting phys_addr to 32) are
>> covered by those CPUs not having PAE/PSE36? One would
>> think that this is valid to imply, but getting cpu_info's phys_bits
>> wrong isn't fatal as long as no addresses beyond 4G would ever
>> be encountered anywhere, whereas using too large an address
>> width here would result in the MTRR writes causing #GP. So
>> when I did this adjustment (a couple of years ago already - this
>> isn't the first submission), I decided to remain on the safe side.
>>
>> Does any of the maintainers have an opinion either way?
>>
> 
> There are definitely CPUs which have PAE but only has a 32-bit address 
> bus.  On the other hand there are tons of chipsets which arbitrary 
> address caps that almost nothing in the system knows about, so I don't 
> think this matters.

The first sentence implies to me that you consider the patch
fine as is, yet the last phrase makes me rather think you want
it adjusted as per Yinghai's response.

In any case, address capping by the chipset doesn't matter
here, all we're after is determining how may bits the MTRRs
(or equivalents) implement (so that size_or_mask and
size_and_mask end up being correct).

Bottom line - I'm confused as to what (if any) adjustments
the patch needs in order to be acceptable.

Jan

