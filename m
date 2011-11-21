Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1KUXXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:23:49 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12702 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1KUXXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:23:48 -0500
Message-ID: <4ECADD83.3090108@caviumnetworks.com>
Date: Mon, 21 Nov 2011 15:23:47 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Daney <ddaney.cavm@gmail.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and HPAGE_SIZE
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com> <alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com> <alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com> <4ECACF68.3020701@gmail.com>  <CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
In-Reply-To: <CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Nov 2011 23:23:47.0748 (UTC) FILETIME=[9EB22640:01CCA8A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2011 02:43 PM, Linus Torvalds wrote:
> On Mon, Nov 21, 2011 at 2:23 PM, David Daney<ddaney.cavm@gmail.com>  wrote:
>>
>> This whole comment strikes me as somewhat dishonest, as at the time David
>> Rientjes wrote it, he knew that there were dependencies on these symbols in
>> the linux-next tree.
>>
>> Now we can add these:
>> +#define HPAGE_SHIFT    ({ BUG(); 0; })
>> +#define HPAGE_SIZE     ({ BUG(); 0; })
>> +#define HPAGE_MASK     ({ BUG(); 0; })
>
> Hell no.
>
> We don't do run-time BUG() things. No way, no how.
>
> If that #define cannot be used, then it damn well shouldn't be defined at all.
>
> David's patch is clearly the right thing to do. Don't try to send me
> the above kind of insane crap.
>

Ok Linus, for you I would recommend against running this git command on 
your tree:

git grep -E '#define.+BUG\(\);'

It's not like there isn't precedence.

David Daney
