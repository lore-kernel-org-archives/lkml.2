Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0KLByy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 20:54:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38469 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab0KLByw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 20:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lSX3KIe7EMbC5+1XJ/Y0d8DCsbpooPv0dOhhqx3K02XVmlZOF1vbQKbzW8IL8OiCG4
         R4SflR1xQq0Wv5BOVbjzT7aUto1AScqUB9tfCcNskO6HFT/YWMhmeQSGzpSPdIMKRoIE
         HokdwtmchPcnwAoG5VYEHxJEmS7alb6lD52dg=
MIME-Version: 1.0
In-Reply-To: <1289473363-29440-5-git-send-email-tj@kernel.org>
References: <1289473363-29440-1-git-send-email-tj@kernel.org>
	<1289473363-29440-5-git-send-email-tj@kernel.org>
Date: Thu, 11 Nov 2010 20:54:51 -0500
Message-ID: <AANLkTimAx0+nXF+yRKyr28H8uYxbsiZizkKG7v0b6HEq@mail.gmail.com>
Subject: Re: [PATCH 4/9] x86: Initialize 32bit logical apicid mapping early
 during boot
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, eric.dumazet@gmail.com,
        yinghai@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 6:02 AM, Tejun Heo <tj@kernel.org> wrote:
> On x86_32, non-standard logical apicid mapping can be used by
> different NUMA setups and the mapping is queried while bringing up
> each CPU using apic->cpu_to_logical_apicid() to build
> cpu_2_logical_apicid[] array.  The logical apicid is then used to
> deliver IPIs and determine NUMA configuration.
>
> Unfortunately, initializing at SMP bring up is too late for percpu
> setup making static percpu variables setup w/o considering NUMA.  This
> also is different from how x86_64 is configured making the code
> difficult to follow and maintain.
>
> This patch updates logical apicid mapping handling such that,
>
> * early_percpu variable x86_cpu_to_logical_apicid replaces
>  cpu_2_logical_apicid[].

You are missing code in setup_percpu.c to copy the values from the
early array to the percpu variable.  This isn't handled automatically.

Also make sure that any direct use of the percpu variable (ie. not via
early_per_cpu()) can happen only after percpu setup.

--
Brian Gerst
