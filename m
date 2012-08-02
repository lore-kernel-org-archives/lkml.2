Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab2HBTuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 15:50:07 -0400
Received: from seven.medozas.de ([5.9.24.206]:55010 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799Ab2HBTuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 15:50:04 -0400
Date: Thu, 2 Aug 2012 21:50:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, pv-drivers@vmware.com,
        vm-crosstalk@vmware.com, cschamp@vmware.com,
        gregkh@linuxfoundation.org
Subject: Re: [vmw_vmci 11/11] Apply the header code to make VMCI build
In-Reply-To: <20120727103455.GA4639@merkur.ravnborg.org>
Message-ID: <alpine.LNX.2.01.1208022145380.30631@frira.zrqbmnf.qr>
References: <1343345980-32397-1-git-send-email-astiegmann@vmware.com> <1343345980-32397-12-git-send-email-astiegmann@vmware.com> <20120727103455.GA4639@merkur.ravnborg.org>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2012-07-27 12:34, Sam Ravnborg wrote:
>> +#ifndef _VMCI_COMMONINT_H_
>> +#define _VMCI_COMMONINT_H_
>> +
>> +#include <linux/printk.h>
>> +#include <linux/vmw_vmci_defs.h>
>
>Use inverse chrismas tree here.
>Longer include lines first, and soret alphabetically when
>lines are of the same length.

So that's where unreadable include lists come from.
Depth-first lexicographically-sorted is a lot less hassle,
especially when it comes to merging patches that each
add one different include.

>> +/*
>> + * Utilility function that checks whether two entities are allowed
>> + * to interact. If one of them is restricted, the other one must
>> + * be trusted.
>> + */
>> +static inline bool vmci_deny_interaction(uint32_t partOne,
>> +					 uint32_t partTwo)
>
>The kernel types are u32 not uint32_t - these types belongs in user-space.

Not really. uint32_t is the C99 type for a 32-bit quantity, and I see
absolutely zero reason not to use standardized things. The only
exception are header files visible to user space where __u32 should
be used for (obscure) reasons of avoiding naming clashes.

(Obscure because uint32_t is always supposed to be 32 bits.)

