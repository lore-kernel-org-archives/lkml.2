Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab0IGSAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 14:00:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59421 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576Ab0IGSA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 14:00:28 -0400
Date: Tue, 7 Sep 2010 19:00:25 +0100
From: Andy Whitcroft <apw@canonical.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch problem
Message-ID: <20100907180025.GD2662@shadowen.org>
References: <23323.1283864982@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23323.1283864982@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 02:09:42PM +0100, David Howells wrote:
> 
> Hi,
> 
> Checkpatch generates the following messages for inline asm strings:
> 
> WARNING: unnecessary whitespace before a quoted newline
> #49: FILE: arch/m32r/include/asm/irqflags.h:31:
> +               "ld24   %0, #0  ; Use 32-bit insn.                      \n\t"
> 
> however, inline asm is more readable if I can tabulate things, including the
> newline markers:
> 
> 	asm volatile (
> 		"ld24	%0, #0	; Use 32-bit insn.			\n\t"
> 		"mvfc	%1, psw	; No interrupt can be accepted here.	\n\t"
> 		"mvtc	%0, psw						\n\t"
> 		"and3	%0, %1, #0xffbf					\n\t"
> 		"mvtc	%0, psw						\n\t"
> 		: "=&r" (tmpreg0), "=&r" (tmpreg1)
> 		:
> 		: "cbit", "memory");
> 
> Can you please fix it, even if it's only to permit multiple TAB chars before
> '\n'.
> 
> Whilst this check is probaly fine for strings to be displayed in some way, this
> doesn't necessarily apply to inline asm strings.  Furthermore, the extra white
> space does not impact the resulting binary.

A tricky one to know how to detect it as different.  Often we do not
have the asm markers to hint us to change style.  This affects us often
as gcc abuses the meaning of almost every character and has different
spacing for them too.

Will think on it.

-apw
