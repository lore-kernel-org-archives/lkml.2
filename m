Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0F3IlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:41:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab0F3IlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:41:11 -0400
Message-ID: <4C2B03E2.6080200@ontolab.com>
Date: Wed, 30 Jun 2010 10:44:18 +0200
From: Christian Stroetmann <stroetmann@ontolab.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-security-module <linux-security-module@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4] security: Yama LSM
References: <20100628184200.GU4175@outflux.net> <alpine.LRH.2.00.1006300854170.14620@tundra.namei.org> <20100630004911.GI4837@outflux.net>
In-Reply-To: <20100630004911.GI4837@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+oRJwnRdaSd88TUsZyygGeDbmj4SbmtRKa8ej
 3QtiMdp18TEHAkWxZjfbkQScBh0f3+IjeFJQk/6inBEaCd6NrD
 QY6WFA7mcIA2bt1yvEfeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning;

On 30.06.2010 02:49, Kees Cook wrote:
> Hi,
>
> On Wed, Jun 30, 2010 at 09:18:32AM +1000, James Morris wrote:
>> On Mon, 28 Jun 2010, Kees Cook wrote:
>>
>>> This adds the Yama Linux Security Module to collect several security
>>> features (symlink, hardlink, and PTRACE restrictions) that have existed
>>> in various forms over the years and have been carried outside the 
>>> mainline
>>> kernel by other Linux distributions like Openwall and grsecurity.
>>>
>>> Signed-off-by: Kees Cook<kees.cook@canonical.com>
>> There were no further complaints, and we seem to have reached a workable
>> consensus on the topic.
>>
>> It's not clear yet whether existing LSMs will modify their base policies
>> to incorporate these protections, utilize the Yama code more 
>> directly, or
>> implement some combination of both.
> I'm hoping we can implement really simple chaining -- nothing fancy.
> Trying to chain comprehensive LSMs seems like it will always fail, but
> putting little LSMs in front of big LSMs seems like an easy win.

No, I can't see why chaining of large LSMs will always fail and I don't 
think that the problem is if an LSM is small or large.
Furthermore, you have taken three protective functions out of other 
security packages that have good technical arguments why they are no 
LSMs and ported them into a new LSM. So what comes next? The next step 
is that you will put more and more functionalities, maybe again taken 
from other packages, into your new LSM with the result that at the end 
it will be a big LSM. And then?
While this is happening now you start to argue implicitly that the large 
LSMs have to follow your way, which means they have to be splitted into 
smaller LSMs. But the real problem is the LSM architecture must be in 
such a form that no protections have to be transformed by you at all.
And I think the future LSM architecture shouldn't be designed this time 
around another LSM, or in other words, around your LSM, but in a way 
that eg. grsecurity fits directly into it.

>> If you're a user of an existing LSM and want these protections, bug the
>> developers for a solution :-)
>>
>> Applied to
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next 
>>
> Thanks!
>
> -Kees

Christian Stroetmann
