Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab2GaNcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:32:52 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55668 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab2GaNcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:32:50 -0400
Message-ID: <5017DE06.3000103@linux.vnet.ibm.com>
Date: Tue, 31 Jul 2012 08:30:46 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Yoder <key@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, anton@samba.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: CRYPTO_DEV_NX merge problem (Re: linux-next: Tree for July 31)
References: <20120731152614.de6ebe9e0d4b8fc6645b793a@canb.auug.org.au> <31974.1343714338@neuling.org>
In-Reply-To: <31974.1343714338@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073113-5806-0000-0000-000017D8F577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 12:58 AM, Michael Neuling wrote:
>> Please do not add anything to linux-next included branches/series that is
>> destined for v3.7 until after v3.6-rc1 is released.
> 
> Looks like there is a merge conflict between:
>   commit 1b074ac867a2bd08a6f12f0feed7d91e06941723
>   Author: Seth Jennings <sjenning@linux.vnet.ibm.com>
>   Subject: powerpc/crypto: rework Kconfig
> 
> and 
>   commit fd297b3a7302ab866306f53c1fd1e97b083fe83e
>   Author: Anton Blanchard <anton@samba.org>
>   powerpc: Enable pseries hardware RNG and crypto modules
> 
> Seth made CRYPTO_DEV_NX a bool and Anton set it as a module.
> 
> Hence I get this with a pseries_defconfig
>   arch/powerpc/configs/pseries_defconfig:372:warning: symbol value 'm' invalid for CRYPTO_DEV_NX
> 
> Seth: any reason this can stay as a tristate?

My patch converted CRYPTO_DEV_NX to a submenu access config
and the functionality that used to be enabled by it is now
enabled by CRYPTO_DEV_NX_ENCRYPT.

The resolution is to change Anton's patch from

+CONFIG_CRYPTO_DEV_NX=m

to

+CONFIG_CRYPTO_DEV_NX=y
+CONFIG_CRYPTO_DEV_NX_ENCRYPT=m

Seth

