Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0DUCCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 22:02:13 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:43736 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab0DUCCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 22:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=Qbxg8e1hYUH+tmnhYaxEmvabHRcLihQoNT0OUIeVQ7HmnDRHbGbXpYPlcFvB/NUY8s
         5ZHtVsNArIqsZdPZumI6xV5RKrpsdlRh0BKw30MY1ESjUwQutnjHy0cLePORFyTUS3rT
         /8uqHqJ+JXtPjOgUtM7hGmbLLrWaVOd4h7S6Y=
Message-ID: <4BCE5C9A.3080805@gmail.com>
Date: Wed, 21 Apr 2010 10:02:02 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: A possible bug in reqsk_queue_hash_req()
References: <i2x9b948ee41004200335vc229a59cvc0a08c35c949d7dd@mail.gmail.com>	 <1271761611.3845.223.camel@edumazet-laptop>	 <u2m9b948ee41004200621zf829996y813c37c5f6a3691f@mail.gmail.com> <1271775681.7895.21.camel@edumazet-laptop>
In-Reply-To: <1271775681.7895.21.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet 写道:
> Le mardi 20 avril 2010 à 21:21 +0800, Li Yu a écrit :
> 
>> In my word, write lock also means mutual exclusion among all writers,
>> is it right?
>>
> 
> Yes, generally speaking.
> 
> But not on this use case.
> 
> This is documented in an include file, if you search for syn_wait_lock
> 
>>> All callers of this reqsk_queue_hash_req() must have the socket locked
>> See. If we always assumed the caller should hold the locked socket
>> first, this is not a bug, but I think we'd better add a comment at
>> header file.
> 
> It is documented, as a matter of fact :)
> 
> 

Great, this isn't a bug, you are right here :)

I just found out these comments about syn_wait_lock, it seem that we need to crossed reference documents for kernel API, a newbie like me, may confused at such similar problems.


> 
