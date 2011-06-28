Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946Ab1F1Uqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:46:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33411 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750708Ab1F1Uqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:46:46 -0400
X-Authenticated: #12510340
X-Provags-ID: V01U2FsdGVkX1/4zaFJbjv4+Z3jC4PLWGa3WsEyh06PAZ+U3DHytb
	mQA8Nj+JthY2up
Message-ID: <4E0A3DB1.8000202@gmx.net>
Date: Tue, 28 Jun 2011 22:46:41 +0200
From: Olaf Freyer <aaron667@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110623 Lightning/1.0b3pre Thunderbird/3.1.11
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: Re: Erroneous package power limit notification since kernel 2.6.39
References: <4DD9092A.4080507@gmx.net>	<loom.20110525T172412-101@post.gmane.org> <20110626182725.3f2eac8d@schatten.dmk.lab>
In-Reply-To: <20110626182725.3f2eac8d@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.06.2011 18:27, schrieb Florian Mickler:
>> Both of my bisection attempts ended near the same set of drm/i915 changes that
>> resulted in non-bootable kernels. Considering I'm using a Intel(R) Core(TM)
>> i7-2720QM with some Intel Sandybridge Chipset graphics those might sound
>> somewhat plausible to someone knowing the internals, but don't help me at all.
> There are 2 untested commits left. But they don't seem to be relevant.
> Guessing on those gives me:
>
> The first bad commit could be any of:
> b0b544cd37c060e261afb2cf486296983fcb56da
> f67a559daaa0e2ba616bfe9438f202bc57bc8c72
> 18b2190ca5bd3f19717421b1591c79c9b0372428
> 6f06ce184c765fd8d50669a8d12fdd566c920859
> 0fc932b8ec36116bb759105ce910b0475e63112a
> 311bd68e024f9006db66cbadc3bd9f62fd663f4b
> 040484af3a4efa65786b6e107fbe74747679e17c
> ccab5c82759e2ace74b2e84f82d1e0eedd932571
> aa9b500ddf1a6318e7cf8b1754696edddae86db9
> d9b6cb568bc6eca8db88357bf8bbb92d42a91b1e
> 92f2584a083986c05fc811bbdf380c3fa7c12296
> 9a4114ffa7b6f5f4635e3745a8dc051d15d4596a
> 633f2ea26665d37bb3c8ae30799aa14988622653
> 63d7bbe9ded4146e3f78e5742b119fa1fdb52665
> 417ae1476de3ae9689a374d70565f41b3474641e
> ea0760cfc00b9e534423fdaf630d1c8ce7a5ede0
> b24e71798871089da1a4ab049db2800afc1aac0c
> fe4402931e43e81a4129eba41d05cf8907603af5
> 65993d64a31844ad444694efb2d159eb9c883e49
> c0c06bd244179f754d68684fd87674585a153e40
> 01fe9dbde19a1a27b8ee63e2d964562962e1eb78
> a37f2f87edc1b6e5932becf6e51535d36b690f2a
> bdd92c9ad287e03a2ec52f5a89c470cd5caae1c2
>
>
>
> I'd guess ccab5c82759e2ace74b2e84f82d1e0eedd932571 could be the
> cause. Can you check if the appended revert of that commit makes
> things disappear? 
It seems like you guessed perfectly correct - reverting the commit makes
those notifications go away at once.
