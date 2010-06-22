Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0FVRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:09:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55938 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542Ab0FVRJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:09:58 -0400
Message-ID: <4C20EE54.2050506@zytor.com>
Date: Tue, 22 Jun 2010 10:09:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Borislav Petkov <bp@amd64.org>, "x86@kernel.org" <x86@kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: intel_cacheinfo: potential NULL dereference?
References: <4C209C15.9090604@gmail.com> <4C209C6E.3060302@gmail.com> <20100622130825.GB27658@aftab> <4C20C478.9030505@gmail.com>
In-Reply-To: <4C20C478.9030505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 07:11 AM, Jiri Slaby wrote:
> On 06/22/2010 03:08 PM, Borislav Petkov wrote:
>> From: Jiri Slaby <jirislaby@gmail.com>
>> Date: Tue, Jun 22, 2010 at 07:20:14AM -0400
>>
>>> On 06/22/2010 01:18 PM, Jiri Slaby wrote:
>>>> Stanse found, that this_leaf->l3 is dereferenced at <<1>>, but checked
>>>> for being NULL at <<2>>. Is the check superfluous or the dev assignment
>>>> should go after the check?
>>>
>>> Oh, and I have another report with same symptoms for show_cache_disable.
>>
>> Right, so I have a patch in tip/x86/cpu
>> (8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0) which reorganizes
>> and cleans up that code. With it, all possible checks land in
>> amd_check_l3_disable() and if they have all been passed, the PCI dev is
>> guaranteed to be properly set. So no need for sprinkling additional NULL
>> checks in the code.
>>
>> How's that?
> 
> Looks good.
> 

Do we need a patch for the existing code to go into -linus and -stable,
though?

	-hpa

