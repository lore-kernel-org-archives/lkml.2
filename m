Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1BABKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 20:10:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39463 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab1BABKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 20:10:22 -0500
Message-ID: <4D475D6B.4030508@zytor.com>
Date: Mon, 31 Jan 2011 17:10:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
References: <4D41E86D.8060205@free.fr> <20110127230013.GO4981@outflux.net> <4D4228CE.5090601@zytor.com> <20110131213847.GF4557@outflux.net> <4D474194.2000709@free.fr> <20110131235231.GJ4557@outflux.net>
In-Reply-To: <20110131235231.GJ4557@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 03:52 PM, Kees Cook wrote:
>
> This worked, thanks! If this tests cleanly for you in qemu, we should get
> this committed.
>

This is wrong for at least one reason; possibly two:

a) it ignores the control to not reload the segment registers (not sure 
if anything still uses them, but...)

b) I'm not sure that init_thread_union is safe for the non-BSP CPU here.

	-hpa
