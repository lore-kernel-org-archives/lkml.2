Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab3AAWom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 17:44:42 -0500
Received: from mail.ispras.ru ([83.149.199.43]:56601 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348Ab3AAWok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 17:44:40 -0500
Message-ID: <50E366D6.7040709@ispras.ru>
Date: Wed, 02 Jan 2013 02:44:38 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] p54pci: don't return zero on failure path in p54p_probe()
References: <1357074661-15784-1-git-send-email-khoroshilov@ispras.ru> <201301012245.43064.chunkeey@googlemail.com>
In-Reply-To: <201301012245.43064.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 01:45 AM, Christian Lamparter wrote:
> On Tuesday 01 January 2013 22:11:01 Alexey Khoroshilov wrote:
>> If pci_set_dma_mask() or pci_set_consistent_dma_mask() fails in p54p_probe(),
>> it breaks off initialization, deallocates all resources, but returns zero.
>>
>> The patch implements proper error code propagation.
> Uh, Thanks!
>
> But wait, I think there's another return 0 in the error
> path. See p54pci.c @ line 558:
>
> mem_len = pci_resource_len(pdev, 0);
> if (mem_len < sizeof(...)) {
> 	dev_err(...)
> 	goto err_disabled_dev;
> }
>
> Do you think you can add a err = -EINVAL; before the goto too?
You are right! But I would say -ENODEV is more popular error code in 
this case.
> [I wonder why this wasn't found by the verification project as
> well? Could it be that pci_resource_len(...) < sizeof(...) is
> somehow always true and this is a dead branch?]
Actually it was found, but I have no direct access to the results at the 
moment. My fault.

Would you like I resend the patch to fix both?

--
Best regards,
Alexey

