Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1BHWGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:06:11 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:41567 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab1BHWGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:06:08 -0500
Message-ID: <4D51BE48.7000406@linux.vnet.ibm.com>
Date: Tue, 08 Feb 2011 20:06:00 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Guillaume Chazarain <guichaz@gmail.com>
CC: Stefan Berger <stefanb@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net
Subject: Re: [PATCH] tpm_tis: Use timeouts returned from TPM
References: <1294774649.1337.7.camel@d941e-10> <AANLkTi=BXgDKk3c97XJ+WiCiiPjiYL3dZPWiGg=i3KXp@mail.gmail.com> <AANLkTi=cfNXONM5EvGPaS7N2kgAbUZmn1Oe+qE9fd7aO@mail.gmail.com>
In-Reply-To: <AANLkTi=cfNXONM5EvGPaS7N2kgAbUZmn1Oe+qE9fd7aO@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11020822-9254-0000-0000-0000005171B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2011 07:45 PM, Guillaume Chazarain wrote:
> [ + jmorris ]
>
> On Thu, Jan 27, 2011 at 11:44 PM, Guillaume Chazarain<guichaz@gmail.com>  wrote:
>> On Tue, Jan 11, 2011 at 8:37 PM, Stefan Berger
>> <stefanb@linux.vnet.ibm.com>  wrote:
>>> The current TPM TIS driver in git discards the timeout values returned
>>> from the TPM.
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c4ff4b829ef9e6353c0b133b7adb564a68054979
>> broke the TPM for me on a thinkpad T410. When using the TPM, dmesg
>> complains:
>>
>> [   65.728310] tpm_tis 00:0b: Operation Timed out
>> [   67.651450] tpm_tis 00:0b: Operation Timed out
>> [   69.669421] tpm_tis 00:0b: Operation Timed out
>>
>> This patch fixes it, so consider it:
>>
>> Tested-by: Guillaume Chazarain<guichaz@gmail.com>
> This patch (https://lkml.org/lkml/2011/1/11/341) fixes a regression
> introduced in 2.6.38-rc3, any chance of having it merged?
>
> Thanks.

This patch solves a bug existent before the commit that made into 
2.6.38-rc3. Prior to such commit, the device driver was using default 
values that were big enough to allow TPM commands to succeed, but that 
stalled the kernel for too long during boot (2 minutes for each command 
sent) when buggy TPMs don't respond.

I'll apply this patch to my tree, and ask James to pull from it.

Rajiv



