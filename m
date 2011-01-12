Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1ALQFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:05:24 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64029 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab1ALQFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:05:21 -0500
MIME-Version: 1.0
In-Reply-To: <4D2D1942.4050905@ahsoftware.de>
References: <4D2B4CE4.9080309@ahsoftware.de>
	<alpine.LFD.2.00.1101101722470.9794@xanadu.home>
	<4D2BFA08.5030104@ahsoftware.de>
	<AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
	<20110111155930.GH11039@n2100.arm.linux.org.uk>
	<4D2D1942.4050905@ahsoftware.de>
Date: Wed, 12 Jan 2011 10:05:19 -0600
Message-ID: <AANLkTimAFp7ORrJLw2d8-i5pK0MZGTyAN5kmRR37ky1v@mail.gmail.com>
Subject: Re: ARM: relocation out of range (when loading a module)
From: Dave Martin <dave.martin@linaro.org>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 9:00 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Hello,

[...]

>                INIT_CALLS
>                CON_INITCALL
>                SECURITY_INITCALL
> +               /*
> +                * TODO: The size of INIT_RAM_FS could easily reach a
> +                * point (~16MB) when loading modules will fail because
> +                * relocations will be out of range. So this place here
> +                * isn't the best one.
> +                */
>                INIT_RAM_FS

In general, do we expect always to be able to avoid the situation
where branches in the kernel may need to cover too large a range ...
and is there any strategy for working aroung it?

If we have problems branching from the modules area into vmlinux, we
could possibly build modules with -fPIC : this would remove the
restriction on branch range, though there would also be some
performance impact for the modules...

Cheers
---Dave
