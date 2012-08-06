Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2HFUHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 16:07:07 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55767 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2HFUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 16:07:03 -0400
Message-ID: <502023E2.70207@gmail.com>
Date: Mon, 06 Aug 2012 16:06:58 -0400
From: Vlad Yasevich <vyasevich@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jan Ariyasu <jan.ariyasu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Ariyasu <jan.ariyasu@hp.com>
Subject: Re: [PATCH 00/13] SCTP: Enable netns
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com> <87mx27rig7.fsf@xmission.com> <50201928.2030802@gmail.com> <874noflrzd.fsf@xmission.com>
In-Reply-To: <874noflrzd.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2012 03:50 PM, Eric W. Biederman wrote:
> Vlad Yasevich <vyasevich@gmail.com> writes:
>
>
>> Hi Eric
>>
>> Associations are looked up by ports, but then verifyed by addresses.
>> Also, associations belong to sockets and simply validating the socket
>> namespace should be sufficient.
>
> True.  Your set of patches isn't quite as likely to malfunction as it
> looked at first glance.  It requires address reuse which happens accross
> namespaces but not too frequently.

Last time I looked at Jan's patches, I though she took care of the 
address re-use issue.  It isn't technically necessary to include 
namespace into the hash mix, but I think it will make chains shorter 
when namespaces are involved.  Might be interesting to look.

>
> As for validating the socket namespace I agree that is the fix and my
> patchset winds up doing it.

Yes, I saw that.

>
>>> The downside with my version is that it does not make all of the sctp
>>> tunables per network namespace the way yours does, but making all of
>>> the tunables per network namespace should be straight forward from
>>> my base.
>>>
>>> My patchset also misses some nice to haves like making the association
>>> id allocation per network namespace.  It is not important for
>>> correctness of the code but it might allow an information leak between
>>> namespaces.
>>
>> Hmm.. this one might be nice to have not from the perspective of leak,
>> but from resource limitation.  Without this, once the id space is
>> global is can be exhausted faster.
>
> It takes a lot of associtations to exhaust the id space, but I have no
> fundamental problems problems with the id allocation being per
> namespace.  I had actually overlooked the local association id when I
> did my patches.   After looking it became clear that making the
> association id global was not necessary so I left it.
>
> The sctp association id is a strange beast.  My personal inclination is
> that the sctp association id really ought to be per sctp socket, but I
> have not looked enough at the sctp userspace API to see if that works in
> practice.  Shrug.
>
> Mostly I am in favor of simple and correct.

Technically association id must be unique within a namespace.  Having 
global id space may be simpler and correct enough as there would be no 
duplication of ids between namespaces.  The only thing of value the 
per/namespace id space provides is that it restored the theoretical 
maximum on sctp associations one can have.

However, this means teaching IDR about namespaces... :)

We can skip it for now.

-vlad
>
> Eric
>

