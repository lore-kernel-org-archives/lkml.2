Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab1KWMMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 07:12:55 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44939 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754181Ab1KWMMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 07:12:53 -0500
Subject: Re: Fast memcpy patch
From: Sasha Levin <levinsasha928@gmail.com>
To: "N. Coesel" <nico@nctdev.nl>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
References: <CPSMTPM-CMT101y332G000633f8@CPSMTPM-CMT101.kpnxchange.com>
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 23 Nov 2011 14:10:41 +0200
Message-ID: <1322050241.3581.15.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-23 at 12:25 +0100, N. Coesel wrote:
> Dear readers,
> I noticed the Linux kernel still uses a byte-by-byte copy method for 
> memcpy. Since most memory allocations are aligned to the integer size 
> of a cpu it is often faster to copy by using the CPU's native word 
> size. The patch below does that. The code is already at work in many 
> 16 and 32 bit embedded products. It should also work for 64 bit 
> platforms. So far I only tested 16 and 32 bit platforms.

[snip]

memcpy (along with other mem* functions) are arch specific - for
example, look at arch/x86/lib/memcpy_64.S for the implementation(s) for
x86.

The code under lib/string.c is simple and should work on all platforms
(and is probably not being used anywhere anymore).

-- 

Sasha.

