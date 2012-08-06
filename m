Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab2HFVkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 17:40:00 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59755 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab2HFVj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 17:39:58 -0400
Message-ID: <502039A8.7080807@gmail.com>
Date: Mon, 06 Aug 2012 17:39:52 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ebiederm@xmission.com, jan.ariyasu@gmail.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.ariyasu@hp.com
Subject: Re: [PATCH 00/13] SCTP: Enable netns
References: <87mx27rig7.fsf@xmission.com> <50201928.2030802@gmail.com> <874noflrzd.fsf@xmission.com> <20120806.134737.1358773847818872075.davem@davemloft.net>
In-Reply-To: <20120806.134737.1358773847818872075.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 04:47 PM, David Miller wrote:
> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Mon, 06 Aug 2012 12:50:46 -0700
>
>> Vlad Yasevich <vyasevich@gmail.com> writes:
>>
>>
>>> Hi Eric
>>>
>>> Associations are looked up by ports, but then verifyed by addresses.
>>> Also, associations belong to sockets and simply validating the socket
>>> namespace should be sufficient.
>>
>> True.  Your set of patches isn't quite as likely to malfunction as it
>> looked at first glance.  It requires address reuse which happens accross
>> namespaces but not too frequently.
>>
>> As for validating the socket namespace I agree that is the fix and my
>> patchset winds up doing it.
>
> FWIW I much prefer Eric's patch set, it was so significantly easier to
> read and validate than Jan's.
>

Yes, but Eric's patch set is missing a very significant piece which is 
per-net sctp tunables/globals.  I think adding that piece in will 
introduce some of the complexities of Jan's patch.

Also, I noticed that Eric went the route of placing sctp netns into 
struct net, but Jan used a generic pointer.  Which one should be used? 
Is there some guidance?

-vlad
