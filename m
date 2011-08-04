Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1HDI0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:26:43 -0400
Received: from service87.mimecast.com ([94.185.240.25]:57607 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751874Ab1HDI0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:26:38 -0400
Message-ID: <4E3A57BA.2040907@arm.com>
Date: Thu, 04 Aug 2011 09:26:34 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Manuel Lauss <manuel.lauss@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>, Ingo Molnar <mingo@elte.hu>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH] shm: fix a race between shm_exit() and shm_init()
References: <20110801180151.GA26686@albatros> <20110801112021.25ec9041.akpm@linux-foundation.org> <20110801190341.GA6898@albatros> <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com> <20110802124530.GA2543@albatros> <20110802135512.b49c9de1.akpm@linux-foundation.org> <d844457bba74be419d2434c533fdb4e1@localhost> <CA+55aFx+JOeDoNzs+1wfdK3kpNPyS9wpU1OT=VAwvWPXfMVuDQ@mail.gmail.com> <20110803113033.1c3c6960@taxman.wild-wind.fr.eu.org> <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
In-Reply-To: <CA+55aFzw-K6XvDzTwHRyqQWdkDO8Zqz8Ak1qgNTzf6a3L9=80A@mail.gmail.com>
X-Enigmail-Version: 1.1.2
X-OriginalArrivalTime: 04 Aug 2011 08:26:29.0302 (UTC) FILETIME=[35747D60:01CC5280]
X-MC-Unique: 111080409263306401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/11 01:35, Linus Torvalds wrote:
> On Wed, Aug 3, 2011 at 12:30 AM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>
>> driver_init() is called from do_basic_setup(), before any initcall...
> 
> Ok, thanks everybody. I think the proper fix is the attached patch.
> It's crazy to have usermode helpers enabled early during boot when
> init etc haven't even been set up.
> 
> So does this finally fix the problem (I realize that there are other
> patches floating around that *also* fix it, so please test this
> without those other patches).

This patch alone doesn't cure the problem... However, if combined with
the pure_initcall patch, it boots correctly.

I'll try to gather some traces later today.

	M.
-- 
Jazz is not dead. It just smells funny...

