Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab0IHVFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:05:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53203 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab0IHVFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:05:17 -0400
Message-ID: <4C87FA80.9080100@zytor.com>
Date: Wed, 08 Sep 2010 14:05:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Nick Lowe <nick.lowe@gmail.com>, Hans-Peter Jansen <hpj@urpla.net>,
        linux-kernel@vger.kernel.org
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
References: <fmbxh-5N8-41@gated-at.bofh.it>	<55BC9463-95B9-4034-AA1E-55042D6E9354@gmail.com>	<201009081115.15544.hpj@urpla.net>	<AANLkTi=U40mzeMh-UJJy=ggVDry2qDWW-MYYyBhS_Kex@mail.gmail.com>	<20100908185605.55671889@lxorguk.ukuu.org.uk>	<AANLkTi=khD7fSVv_tC6TogimjJshEErj6Em8mCcDF+SM@mail.gmail.com>	<20100908200715.2e56d0be@lxorguk.ukuu.org.uk>	<AANLkTi=FNFKmBgobH4q-GHguHM-0UOCQpa7JhPhyZZHG@mail.gmail.com> <20100908221144.73066e2d@lxorguk.ukuu.org.uk>
In-Reply-To: <20100908221144.73066e2d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2010 02:11 PM, Alan Cox wrote:
> 
> Getting the stuff right in the current kernel makes it easier to backport
> and fix and do tidily. It's not as if NOPL is complicated to emulate.

The execution phase is easy ;)  The parsing phase is rather hard.  This
is part of why I would much rather see a single x86 interpreter in the
kernel, and the one single interpreter that we need anyway is the one in
KVM.

I haven't looked at what it would take to generalize it to also support
trap and emulate of arbitrary instructions (not just NOPL and CMOV and
so on), but x86 is subtle and quick to anger, and doing it wrong can
trivially introduce security holes.

	-hpa
