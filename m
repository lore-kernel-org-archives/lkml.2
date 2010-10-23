Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0JWRk2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:40:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24139 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0JWRk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:40:27 -0400
Message-ID: <4CC31D6E.6040206@kernel.org>
Date: Sat, 23 Oct 2010 10:37:50 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100914 SUSE/3.0.8 Thunderbird/3.0.8
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [BUG 2.6.36] early serial console undefined refs
References: <20101023144352.GA2818@Krystal>
In-Reply-To: <20101023144352.GA2818@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2010 07:43 AM, Mathieu Desnoyers wrote:
> Hi,
> 
> Building 2.6.36 fails for me with the following link error (config below).
> I think commit f4ed2877b16e8146427306aea8819adac5c88374 is very likely to be the
> culprit, but given other changes that were done afterward, the fix is not as
> easy as a simple revert.
> 
> Thoughts ?
> 
>   Building modules, stage 2.
>   MODPOST 65 modules
>   LD      arch/x86/boot/setup.elf
> arch/x86/boot/early_serial_console.o: In function `early_serial_init':
> /home/compudj/git/morestable/linux-2.6-lttng/arch/x86/boot/early_serial_console.c:40: undefined reference to `early_serial_base'

your tree may have problem. Did you try clean tree from Linus ?

early_seria_console.c

#include "boot.h"
...
static void early_serial_init(int port, int baud)


and in boot.h, we have
/* early_serial_console.c */
extern int early_serial_base;


Thanks

	Yinghai

