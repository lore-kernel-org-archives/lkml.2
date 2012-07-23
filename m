Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2GWHHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:07:23 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42176 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab2GWHHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:07:22 -0400
Message-ID: <500CF782.4060407@parallels.com>
Date: Mon, 23 Jul 2012 11:04:34 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Shuah Khan <shuah.khan@hp.com>, <js1304@gmail.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <shuahkhan@gmail.com>
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
References: <1342221125.17464.8.camel@lorien2> <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com> <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com> <1342407840.3190.5.camel@lorien2> <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com> <alpine.DEB.2.00.1207160915470.28952@router.home> <alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com> <alpine.DEB.2.00.1207161506390.32319@router.home> <alpine.DEB.2.00.1207161642420.18232@chino.kir.corp.google.com> <alpine.DEB.2.00.1207170929290.13599@router.home> <CAOJsxLECr7yj9cMs4oUJQjkjZe9x-6mvk76ArGsQzRWBi8_wVw@mail.gmail.com> <alpine.DEB.2.00.1207171005550.15061@router.home>
In-Reply-To: <alpine.DEB.2.00.1207171005550.15061@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 07:11 PM, Christoph Lameter wrote:
> On Tue, 17 Jul 2012, Pekka Enberg wrote:
> 
>> Well, even SLUB checks for !name in mainline so that's definitely
>> worth including unconditionally. Furthermore, the size related checks
>> certainly make sense and I don't see any harm in having them as well.
> 
> There is a WARN_ON() there and then it returns NULL!!! Crazy. Causes a
> NULL pointer dereference later in the caller?
> 

It obviously depends on the caller.
Although most of the calls to kmem_cache_create are made from static
data, we can't assume that. Of course whoever is using static data
should do those very same tests from the outside to be safe, but in case
they do not, this seems to fall in the category of things that make
debugging easier - even if we later on get to a NULL pointer dereference.

Your mentioned bias towards minimum code size, however, is totally
valid, IMHO. But I doubt those checks would introduce a huge footprint.
I would imagine you being much more concerned about being able to wipe
out entire subsystems like memcg, which will give you a lot more.
