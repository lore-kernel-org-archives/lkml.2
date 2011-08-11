Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1HKNF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 09:05:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38092 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1HKNFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 09:05:53 -0400
Message-ID: <4E43D3AE.70901@gmail.com>
Date: Thu, 11 Aug 2011 15:05:50 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/9] x86 EFI boot stub
References: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
In-Reply-To: <1313060386-4858-1-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2011 12:59 PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> This series adds support for an EFI boot stub, similar to the existing
> BIOS boot stub. The result is that you can boot a bzImage on an EFI
> machine without the use of a boot loader by making the bzImage appear
> to the EFI firmware to be an EFI application. Also, a single bzImage
> can be booted on either a BIOS or EFI machine.
>
> Using the EFI boot stub has the advantage that the kernel is
> responsible for configuring the machine to the point where we can
> fully boot the kernel, so we are no longer at the mercy of the boot
> loader.
>
Fails to boot here. I thought changing characteristics from 0x60500020 to 0xe0500020 would help, but no. :/
This change would make the code section writable.

FileAlignment you use is probably wrong, I think it should be 0x200 not 0x2000 .

Maybe you need to add a data section and fix SizeOfInitializedData too?

It just hangs on a blinking cursor, no idea if it actually started executing anything yet or not, since nothing is printed out.

~Maarten

