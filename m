Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab1KRROX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:14:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52374 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab1KRROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:14:22 -0500
Message-ID: <4EC69269.7060505@gmail.com>
Date: Fri, 18 Nov 2011 09:14:17 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 2/2] hugetlb: Provide safer dummy values for HPAGE_MASK
 and HPAGE_SIZE
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <1321567050-13197-3-git-send-email-ddaney.cavm@gmail.com> <4EC61DB1.3090608@mvista.com>
In-Reply-To: <4EC61DB1.3090608@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 12:56 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 18-11-2011 1:57, David Daney wrote:
>
>> From: David Daney<david.daney@cavium.com>
>
>> It was pointed out by David Rientjes that the dummy values for
>> HPAGE_MASK and HPAGE_SIZE are quite unsafe. It they are inadvertently
>> used with !CONFIG_HUGETLB_PAGE, compilation would succeed, but the
>> resulting code would surly not do anything sensible.
>>
>> Place BUG() in the these dummy definitions, as we do in similar
>> circumstances in other places, so any abuse can be easily detected.
>>
>> Since the only sane place to use these symbols when
>> !CONFIG_HUGETLB_PAGE is on dead code paths, the BUG() cause any actual
>> code to be emitted by the compiler.
>
> You mean "doesn't cause"?

Yes.

I mentioned this in a different message to akpm, but I am not sure if I 
should resend the patch with a corrected change log.

David Daney

>
>> Cc: David Rientjes<rientjes@google.com>
>> Signed-off-by: David Daney<david.daney@cavium.com>
>
> WBR, Sergei
>
>

