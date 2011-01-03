Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab1ACVHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 16:07:51 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43606 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab1ACVHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 16:07:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=pu0izv9YzURuQ01Q8GpsPUwqRA55imeDeQoC6qcO+B6PqTSsnYkekhFpwJFjNFA7DI
         cKSNGEb3KsAciOYwKqLTYDvxjl7qwpDXTEpMU1oir8xOmzl8FSXkv9N+2dsxBlGICoXV
         RFpIyK8vbm2/E17XA3swcAuspPG3nG/USRfj0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110103.115248.179942629.davem@davemloft.net>
References: <1294020104-17124-1-git-send-email-sedat.dilek@gmail.com>
	<20110103.115248.179942629.davem@davemloft.net>
Date: Mon, 3 Jan 2011 22:07:48 +0100
Message-ID: <AANLkTina2xL94To2WrU_Y=O175iTO5mTaf8pwC0UGfRp@mail.gmail.com>
Subject: Re: [PATCH] ksz884x: Fix section mismatch derived from
 pci_device_driver variable
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 3, 2011 at 8:52 PM, David Miller <davem@davemloft.net> wrote:
> From: Sedat Dilek <sedat.dilek@googlemail.com>
> Date: Mon,  3 Jan 2011 03:01:44 +0100
>
>> WARNING: drivers/net/ksz884x.o(.data+0x18): Section mismatch in reference from the variable pci_device_driver to the function .init.text:pcidev_init()
>> The variable pci_device_driver references
>> the function __init pcidev_init()
>> If the reference is valid then annotate the
>> variable with __init* or __refdata (see linux/init.h) or name the variable:
>> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,
>>
>> This patch fixes the warning.
>>
>> Tested with linux-next (next-20101231)
>>
>> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
>
> pcidev_init() should be marked __devinit instead of __init to fix this
> bug.
>

I have sent a new fixed version.

- Sedat -
