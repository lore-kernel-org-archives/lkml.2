Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab0JOP1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:27:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44582 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab0JOP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:27:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OuQIhmyz71+Nb7jlZj/ZNAAZ8NrhUZY38zV0oW4rMhWJ5sBdEwIbIfbXGhBvz/MUJO
         xO8BBS6MxKaDjSeugu238hHzb8OaMgrAKTSQFxPKZno9BOUJl1EW+mJ64Kd9oEmCwza7
         8Tfu6OdqKlsD8G0xO8R4NVJHn6WX83HZd7XNo=
MIME-Version: 1.0
In-Reply-To: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
References: <1287152120-7201-1-git-send-email-felipe.contreras@gmail.com>
Date: Fri, 15 Oct 2010 17:25:07 +0300
Message-ID: <AANLkTinjd6_X62XPAvHNK4Tf233yD0-LKBBe96CE8_T2@mail.gmail.com>
Subject: Re: [PATCH .36-rc8] arm: mm: allow, but warn, when issuing ioremap()
 on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Woodruff <r-woodruff2@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 5:15 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
>
> Drivers have been relying on this behavior, but done so wrongly.
> However, rather than breaking drivers from .35 to .36, we should warn on
> .36 and only break on .37. This way we give a chance for contributors to
> fix the issues.
>
> According to ARM, the behavior of having multiple mappings is
> unspecified from ARMv6+. This causes real issues specially on modern
> hardware, and specially with speculative prefetching. So drivers need to
> be fixed.
>
> Also, since current hardware has palliative meassures to deal with
> multiple mappings with the same memory type but diferent cacheability
> attributes, ensure that such restriction is taking place.

Ah, disregard this, a similar one is on .36-rc8 already (06c1088), I
wasn't CC'ed.

-- 
Felipe Contreras
