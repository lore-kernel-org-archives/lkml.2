Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3AIKfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 05:35:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:59478 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3AIKfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 05:35:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 1/4] gpiolib: introduce descriptor-based GPIO interface
Date: Wed, 9 Jan 2013 10:35:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301081259.29839.arnd@arndb.de> <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com>
In-Reply-To: <CAAVeFu+4VbCbj9TaeMm+NMDJ9_M4-j4O0ONF7Yh_un63wS38+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301091035.23206.arnd@arndb.de>
X-Provags-ID: V02:K0:yswi4DIaXRtpZkaO84DyAlXmUL/TlmlH0+vCJIyg5lN
 Q2tJvbSYaj4S0rIdO91dKvA4wbiTmUmkElOrGn6KKLThurVKgD
 srnZMwHyCvFWjk2lxgZP/JxK0kAKrJOlZbLb1SZA1tIgjgh7bH
 +NyrGmvVPzB7GqFlRWAktpu0Q0wj549vyO+fsHGc7kHfLTasAK
 OPRSP91TOcuuCkCEg85k0SpkiO3OyShK/9w604W/PQaUpJf+5g
 GhvCwgsnWNbShuUaUZ2CtwT+9fMIWtx9pgbSFG34VBS7/wA9U+
 GF/1sdurcXnwBjymsSOM6mpFDLs0dnEO4SeX/uSBn7wIPFF3z/
 Kgptw4tv0w6dJ/Qkphms=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2013, Alexandre Courbot wrote:
> On Tue, Jan 8, 2013 at 9:59 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > Please avoid the use of IS_ERR_OR_NULL(), especially on interfaces you
> > introduce yourself. AFAICT, gpiod_get cannot return NULL, so you
> > should not check for that.
> 
> Sure - you sound like IS_ERR_OR_NULL() is generally considered evil,

Correct.

> may I ask why this is the case?

It's very hard to get right: either you are interested in the error code,
and then you don't have one in some cases, or you don't care but have
to check for it anyway. When you define a function, just make it clear
what the expected return values are, either NULL for error or a negative
ERR_PTR value, but not both.

	Arnd
