Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1FCFtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:49:12 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43933 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1FCFtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BY0Foq1+xOSZcvMiG1ib1jwQrg/oBJLfYOlPqBY9SS6me7g2VnftplX6P4xTX1SkRK
         alGFICDJLlMFDPaOjmW8A+4Rjfs2Rkk69Z+7UgREOpXBePRk7YuUGYqx3W3whWU3eqyt
         KSC4siIWDdfPAhXhvJdbnjsJjQC08N6KQC/dk=
MIME-Version: 1.0
In-Reply-To: <4DE7D2AC.1070503@tilera.com>
References: <201106021424.p52EO91O006974@lab-17.internal.tilera.com>
	<alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com>
	<4DE7D2AC.1070503@tilera.com>
Date: Fri, 3 Jun 2011 08:49:10 +0300
X-Google-Sender-Auth: Tf5jsKv-5FQYhqDPi_WWll95WBA
Message-ID: <BANLkTinjCbhiwRfQ_aN5wtbYipQB6gv5AA@mail.gmail.com>
Subject: Re: [PATCH] slub: always align cpu_slab to honor cmpxchg_double requirement
From: Pekka Enberg <penberg@kernel.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 9:13 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> On 6/2/2011 1:16 PM, David Rientjes wrote:
>> On Thu, 2 Jun 2011, Chris Metcalf wrote:
>>> On an architecture without CMPXCHG_LOCAL but with DEBUG_VM enabled,
>>> the VM_BUG_ON() in __pcpu_double_call_return_bool() will cause an early
>>> panic during boot unless we always align cpu_slab properly.
>>>
>>> In principle we could remove the alignment-testing VM_BUG_ON() for
>>> architectures that don't have CMPXCHG_LOCAL, but leaving it in means
>>> that new code will tend not to break x86 even if it is introduced
>>> on another platform, and it's low cost to require alignment.
>>>
>>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> Acked-by: David Rientjes <rientjes@google.com>
>>
>>> ---
>>> This needs to be pushed for 3.0 to allow arch/tile to boot.
>>> I'm happy to push it but I assume it would be better coming
>>> from an mm or percpu tree.  Thanks!
>>>
>> Should also be marked for stable for 2.6.39.x, right?
>
> No, in 2.6.39 the irqsafe_cpu_cmpxchg_double() was guarded under "#ifdef
> CONFIG_CMPXCHG_LOCAL".  Now it's not.  I suppose we could take the comment
> change in percpu.h for 2.6.39, but it probably doesn't merit churning the
> stable tree.

Yup. Looks good. Christoph?
