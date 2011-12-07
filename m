Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab1LGNnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:43:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab1LGNnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:43:08 -0500
Message-ID: <4EDF6D66.5030003@redhat.com>
Date: Wed, 07 Dec 2011 15:43:02 +0200
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, Amit Shah <amit.shah@redhat.com>,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/12] virtio: s4 support
References: <cover.1323199985.git.amit.shah@redhat.com> <87wra8j13m.fsf@rustcorp.com.au> <20111207104459.GR12507@redhat.com>
In-Reply-To: <20111207104459.GR12507@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 12:44 PM, Gleb Natapov wrote:
> On Wed, Dec 07, 2011 at 05:54:29PM +1030, Rusty Russell wrote:
>> On Wed,  7 Dec 2011 01:18:38 +0530, Amit Shah<amit.shah@redhat.com>  wrote:
>>> Hi,
>>>
>>> These patches add support for S4 to virtio (pci) and all drivers.
>>
>> Dumb meta-question: why do we want to hibernate virtual machines?
>>
> For instance you want to hibernate your laptop while it is running a virtual
> machine. You can pause them of course, but then time will be incorrect
> inside a guest after resume.

Exactly. Today with do that through live migration into a file, we call 
it external hibernation. The problem that it is transparent from the 
guest and thus it loses time keeping. Even NTP can't handle it since if 
it has more than 0.5% delay it stops syncing.

The solution is to do it through s4 where the guest gets a notification 
when it resumes.


>
>> I figure there's a reason, but it seems a bit weird :)
>>
>> Thanks,
>> Rusty.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

