Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab1KYMIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 07:08:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50685 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab1KYMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 07:08:13 -0500
Message-ID: <4ECF8528.9080800@gmail.com>
Date: Fri, 25 Nov 2011 13:08:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111114 Thunderbird/9.0
MIME-Version: 1.0
To: Nuno Santos <nsantos@edigma.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Floating point usage inside kernel
References: <S1754322Ab1KYK6W/20111125105822Z+929@vger.kernel.org> <4ECF789F.3040001@edigma.com>
In-Reply-To: <4ECF789F.3040001@edigma.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 12:14 PM, Nuno Santos wrote:
> Doing a grep -r kernel_fpu_begin * on kernel source dir I can find
> several references to this functions but not them is included in the
> include dir. Which include do I need to have this functions found in
> compile time?

It is defined in arch specific includes. For x86 in asm/i387.h (in
arch/x86/include).

> Am I even sailing in the right direction?

You should generally not use that anyway. It's not portable and disables
preemption.

Can't you do the computations in userspace? And why it cannot be
switched to integer types -- what algorithm is that? Some math function?

reagards,
-- 
js
