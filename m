Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab0I2Ilg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:41:36 -0400
Received: from daytona.panasas.com ([67.152.220.89]:57791 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755275Ab0I2Ilf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:41:35 -0400
Message-ID: <4CA2FBBB.3040004@panasas.com>
Date: Wed, 29 Sep 2010 10:41:31 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>,
        "David S. Miller" <davem@davemloft.net>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
References: <4CA09977.80506@panasas.com> <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com> <20100928134721.f79a5955.akpm@linux-foundation.org> <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
In-Reply-To: <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 08:41:34.0462 (UTC) FILETIME=[1F5431E0:01CB5FB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 10:57 PM, Linus Torvalds wrote:
> On Tue, Sep 28, 2010 at 1:47 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>>
>> And I misread that, assuming that it's just a wrapper around
>> eth_mac_addr().  Only it isn't, because it passes eth_mac_addr() the
>> MAC address's address directly (with ->sa_data).  But eth_mac_addr()
>> expects a `struct sockaddr *'.
>>
>> And for some wtf reason, eth_mac_addr() passes that `struct
>> sockaddr *' in a `void *', thus cunningly hiding the bug.
>>
>> Yeah, please revert it.
> 
> Well, the alternative would be to just fix uml_net_set_mac(). The code
> before the patch was clearly crap too, so reverting may make it work,
> but gets us back to a stupid situation with two different initializers
> for one field.
> 
> So perhaps something like the attached patch would make it work, and
> have the locking in place that apparently people think it should have?
> 
> Boaz?
> 

OK I get the picture. We should attempt a proper fixing. Well since
I get to test it, then I get to fix it as well, right ;-)?

With this I'm now back to my usual: boots fine but half of the times
not halting. But I think that's a Fedora12 problem with interaction
with uml. (Which I do not have time to investigate)

>                      Linus

Thanks, have a good day
Boaz
