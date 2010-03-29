Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0C2U4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:56:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51478 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab0C2U4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:56:18 -0400
Message-ID: <4BB113E7.4050200@zytor.com>
Date: Mon, 29 Mar 2010 13:56:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
CC: Matthew Wilcox <matthew@wil.cx>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de
Subject: Re: [PATCH] dma-mapping: Remove WARN_ON in dma_free_coherent
References: <1269886161-2616-1-git-send-email-stefan.bader@canonical.com> <20100329204123.GA32165@parisc-linux.org> <4BB112B3.6070001@canonical.com>
In-Reply-To: <4BB112B3.6070001@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 01:50 PM, Stefan Bader wrote:
> Matthew Wilcox wrote:
>> On Mon, Mar 29, 2010 at 08:09:21PM +0200, Stefan Bader wrote:
>>> But it seems modifying that driver would be a bigger effort and maybe
>>> not really worthwile as it is a rather old driver. On the other side
>>> I was told [1] that this WARN_ON applies only to ARM which could sleep
>>> in the free path and it is just bogus for X86. As the code is in
>>> arch/x86 it would never be used for anything else than X86 and if
>>> its truely bogus on X86, couldn't it get removed?
>>
>> My suggestion was that you remove it from the Ubuntu kernel, not submit
>> it upstream.
>>
> No, I did not want to give that impression. But my rational was, that if this is
>  really a warning that has no meaning on X86, then why should it stay in code
> that is x86 only. And then why should that not go upstream.
> When I tried following the code, it looked like this was carried forward for
> quite a while and maybe it just stayed because nobody noticed it.
> But with KVM using that scsi driver, other distros might see the same bogus
> warning and then it would be beneficial for all to just remove it.
> If Ingo or hpa say it is needed, ok. But its at least worth a go.
> 


-	WARN_ON(irqs_disabled());       /* for portability */
                                           ^^^^^^^^^^^^^^^

It's there to keep people from writing their drivers incorrectly,
testing them on x86 only, and then pushing them upstream.

Nacked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
