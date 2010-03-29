Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0C2UvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:51:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44840 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab0C2UvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:51:10 -0400
Message-ID: <4BB112B3.6070001@canonical.com>
Date: Mon, 29 Mar 2010 22:50:59 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       James.Bottomley@suse.de
Subject: Re: [PATCH] dma-mapping: Remove WARN_ON in dma_free_coherent
References: <1269886161-2616-1-git-send-email-stefan.bader@canonical.com> <20100329204123.GA32165@parisc-linux.org>
In-Reply-To: <20100329204123.GA32165@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Mar 29, 2010 at 08:09:21PM +0200, Stefan Bader wrote:
>> But it seems modifying that driver would be a bigger effort and maybe
>> not really worthwile as it is a rather old driver. On the other side
>> I was told [1] that this WARN_ON applies only to ARM which could sleep
>> in the free path and it is just bogus for X86. As the code is in
>> arch/x86 it would never be used for anything else than X86 and if
>> its truely bogus on X86, couldn't it get removed?
> 
> My suggestion was that you remove it from the Ubuntu kernel, not submit
> it upstream.
> 
No, I did not want to give that impression. But my rational was, that if this is
 really a warning that has no meaning on X86, then why should it stay in code
that is x86 only. And then why should that not go upstream.
When I tried following the code, it looked like this was carried forward for
quite a while and maybe it just stayed because nobody noticed it.
But with KVM using that scsi driver, other distros might see the same bogus
warning and then it would be beneficial for all to just remove it.
If Ingo or hpa say it is needed, ok. But its at least worth a go.

-Stefan
