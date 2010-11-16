Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab0KPBO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 20:14:59 -0500
Received: from claw.goop.org ([74.207.240.146]:39337 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759009Ab0KPBO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 20:14:57 -0500
Message-ID: <4CE1DB0F.8030808@goop.org>
Date: Mon, 15 Nov 2010 17:14:55 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Xen-devel <xen-devel@lists.xensource.com>,
        Stephen Tweedie <sct@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 1/3] xen dom0: Add support for the platform_ops
 hypercall
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>	<0aa82d86c699890ce3661927f176045fc8e47156.1289519130.git.jeremy.fitzhardinge@citrix.com> <20101115154814.GB345@dumpdata.com>
In-Reply-To: <20101115154814.GB345@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2010 07:48 AM, Konrad Rzeszutek Wilk wrote:
>> +typedef struct xenpf_settime xenpf_settime_t;
>> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_settime_t);
> We aren't using this..
>> +typedef struct xenpf_add_memtype xenpf_add_memtype_t;
>> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_add_memtype_t);
> .. nor this..
>> +typedef struct xenpf_del_memtype xenpf_del_memtype_t;
>> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_del_memtype_t);
> .. neither this one.
>> +typedef struct xenpf_read_memtype xenpf_read_memtype_t;
>> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_read_memtype_t);
> ..whoa, didn't know we had that many.
>> +
>> +#define XENPF_microcode_update    35
>> +struct xenpf_microcode_update {
>> +    /* IN variables. */
>> +    GUEST_HANDLE(void) data;          /* Pointer to microcode data */
>> +    uint32_t length;                  /* Length of microcode data. */
>> +};
>> +typedef struct xenpf_microcode_update xenpf_microcode_update_t;
>> +DEFINE_GUEST_HANDLE_STRUCT(xenpf_microcode_update_t);
> OK, we are using this one.
>
> .. snip .. 
>
> Why not just introduce the one we are using (just one right now)
> and on subsequent patches that enable the functionality add it in this file?

The main reason is that if some other branch also brings in platform.h
then its easier to merge two copies of the same file rather than two
subsets.

    J
