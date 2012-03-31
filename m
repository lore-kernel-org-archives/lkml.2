Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab2CaVbj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:31:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:57338 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751977Ab2CaVbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:31:38 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18+Q4FK9+w+B3SWQVWM3zUAsw74QUdUh4/tXoaDw2
	Cl1HkxAkTjNklp
Message-ID: <4F77779F.3010607@gmx.de>
Date: Sat, 31 Mar 2012 21:31:11 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Wang YanQing <udknight@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, spock@gentoo.org
Subject: Re: [PATCH] video:uvesafb: Fix oops that uvesafb try to execute NX-protected
 page
References: <20120327100136.GA3829@udknight> <20120327143243.015ecff6@pyramind.ukuu.org.uk>
In-Reply-To: <20120327143243.015ecff6@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2012 01:32 PM, Alan Cox wrote:
> On Tue, 27 Mar 2012 18:01:36 +0800
> Wang YanQing <udknight@gmail.com> wrote:
> 
>>
>> Ok! I try to check pcibios_enabled first, but get some opposition by Alan Cox,
>> but I want to make thing work and fix the oops, so I choice the simple way to
>> check the (__supported_pte_mask & _PAGE_NX) instead of to check this variable plus
>> pci kernel boot parameter, pci mmconfig works or not, and more, and more. It is not
>> the best method, but it works and maybe all will feel happy.

Wang, could you please write a better commit message, at least you could
include the oops that your patch fixes.

> Apart from adding a helper in the includes for the arch code of
> 
> 	static inline is_nx_enabled(void)
> 	{
> 		return !!(__supported_pte_mask & _PAGE_NX);
> 	}

As this check is already done in a few other places I think there should
be a separate patch that adds this helper and ports all existing code to
use it.

So, does anyone have any objection against me taking this patch as is?


Thanks,

Florian Tobias Schandinat
