Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KIVex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:34:53 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58008 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0KIVev convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:34:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HgugDrbcU2ngpdT+P9LvtZoeUi/SOw80n3ZnrGl01ebwCMl/mhq0t7w8gpx0qbVe4g
         jjVFx4yKspEOTIvgDNtI3e/KcRDQPHuA71Bdc48fNMDWN/TQVG2uSmUAlSxq2cKM7uOS
         IwjTsymeuZacTCwmmgUS49MT6V5+ypSXkC7zU=
MIME-Version: 1.0
In-Reply-To: <4CD9B463.6090504@kernel.org>
References: <20101025235804.GA11760@outflux.net>
	<AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
	<20101109205008.GU5876@outflux.net>
	<4CD9B463.6090504@kernel.org>
Date: Tue, 9 Nov 2010 23:34:50 +0200
X-Google-Sender-Auth: Tb2OI-pNZCNJowaz0e6b4AGBOuA
Message-ID: <AANLkTin1FmyN7_-Jg9AWizfQ04+rVWhFRcpYZykBRJ0f@mail.gmail.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
From: Pekka Enberg <penberg@kernel.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 10:51 PM, Pekka Enberg <penberg@kernel.org> wrote:
> On 9.11.2010 22.50, Kees Cook wrote:
>>
>> Hi Pekka,
>>
>> On Tue, Nov 09, 2010 at 10:43:07PM +0200, Pekka Enberg wrote:
>>>
>>> On Tue, Oct 26, 2010 at 2:58 AM, Kees Cook<kees.cook@canonical.com>
>>>  wrote:
>>>>
>>>> CVE-2010-4072
>>>>
>>>> The old shm interface will leak a few bytes of stack contents.
>>>> Explicitly
>>>> clear structure using memset instead of C99-style initialization in case
>>>> there are ever holes in the packing.
>>>>
>>>> Cc: stable<stable@kernel.org>
>>>> Signed-off-by: Kees Cook<kees.cook@canonical.com>
>>>
>>> This looks like a genuine bug fix but I don't see this patch in
>>> mainline. Why is that?
>>
>> No one has committed it. I don't know why; I've sent it a few times now.
>
> Andrew, would you mind picking this up and route it to the appropriate
> person if necessary?
>
> Acked-by: Pekka Enberg <penberg@kernel.org>

Oh, there seems to be a partial fix in mainline:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3af54c9bd9e6f14f896aac1bb0e8405ae0bc7a44

Hmmh?
