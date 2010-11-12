Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab0KLVZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:25:00 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:45866 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab0KLVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:24:59 -0500
Message-ID: <4CDDB0A2.7090606@linux.vnet.ibm.com>
Date: Fri, 12 Nov 2010 19:24:50 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Safford <safford@watson.ibm.com>
CC: David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
References: <1289514356.2726.18.camel@localhost.localdomain> <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <6651.1289504931@redhat.com>  <22962.1289571072@redhat.com> <1289573330.4341.31.camel@localhost.localdomain>
In-Reply-To: <1289573330.4341.31.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Dave,

On 11/12/2010 12:48 PM, David Safford wrote:

> On Fri, 2010-11-12 at 14:11 +0000, David Howells wrote:
>> Mimi Zohar<zohar@linux.vnet.ibm.com>  wrote:
>>
>>>>> +	module_put(chip->dev->driver->owner);
>>>> Where's the corresponding module_get()?  I suspect this should be wrapped to
>>>> match tpm_chip_find_get().
>>>>
>>>> David
>>> The module_get() is in tpm_chip_find_get(), which is just a helper.
>>> (It's used this way throughout tpm.c)
>> I'd make a function tpm_chip_find_put() just to wrap module_put() and then
>> place it with tpm_chip_find_get() in the sources.  That makes it easier to see
>> what's going on.
> Or alternately rename the helper to tpm_chip_find_and_module_get()?
> In either case, this is really up to Rajiv (the maintainer for tpm.c
> who has already acked this patch), as this usage already appears in
> other places in tpm.c. There would have to be a separate patch fixing
> this for all of the instances. Rajiv, your thoughts?
>
> dave
Rename the helper to tpm_chip_find_and_module_get() solves the naming issue in a simpler and better way in my opinion.

Thanks,
Rajiv

