Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab0KXGZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:25:27 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38455 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0KXGZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:25:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=EAd2FVW2KWiBHA6FgmQ/LTpo3f/k9pnp130XJvZDLjPCQy8/3eIsotU6wil/nTqT+z
         lCNlxamUP0TGLqwpYpNIxBJLIW2DOPcIAXcu21vN/nNW9PwCiPfTrp2l9nOQirihSwjz
         NmFOC2bH930uu8mEwnzL3+tBgyYrNp2JX2+qs=
Message-ID: <4CECAFD1.10506@gmail.com>
Date: Tue, 23 Nov 2010 22:25:21 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
Newsgroups: gmane.linux.file-systems,gmane.linux.kernel
To: =?ISO-8859-1?Q?C=E9dric_Villemain?= 
	<cedric.villemain.debian@gmail.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: Bcache version 9
References: <20101121140808.GA6429@moria> <AANLkTim7_Lm3U+jHe7KG8Ha9rqe=jg2yffb8NA8RLiGM@mail.gmail.com>
In-Reply-To: <AANLkTim7_Lm3U+jHe7KG8Ha9rqe=jg2yffb8NA8RLiGM@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2010 03:35 PM, Cédric Villemain wrote:
> First I am really happy to see this project appearing here.
>
> 2010/11/21 Kent Overstreet<kent.overstreet@gmail.com>:
>> Bcache is a patch to use SSDs to transparently cache arbitrary block
>> devices. Its main claim to fame is that it's designed for the
>> performance characteristics of SSDs - it avoids random writes and
>> extraneous IO at all costs, instead allocating buckets sized to your
>> erase blocks and filling them up seqentially. It uses a hybrid
>> btree/log, instead of a hash table as some other caches.
>
> Is it its main diff with flashcache ?
> https://github.com/facebook/flashcache/blob/master/doc/flashcache-doc.txt

Yeah. It's a more complex approach, but it's capable of significantly 
higher performance. Performance has regressed some lately (I've been 
concentrating on other things and don't really have the hardware for 
performance work), but a month or so ago it was benchmarking around 50% 
higher than flashcache, with mysql on an X25-E.

>
>>
>> It does both writethrough and writeback caching - it can use most of
>> your SSD for buffering random writes, which are then flushed
>> sequentially to the backing device. Skips sequential IO, too.
>>
>> Current status:
>> Recovering from unclean shutdown has been the main focus, and is now
>> working magnificantly - I'm having no luck breaking it. This version
>> looks to be plenty safe enough for beta testing (still, make backups).
>>
>> Proper discard support is in and enabled by default; bcache won't ever
>> write to the same location twice without issuing a discard to that
>> bucket.
>
>   Is it relative to Torn Page possible issue outline by flashcache devel ?

Kind of. Bcache isn't subject to that issue, but that's because bcache 
is cow and always strictly orders writes.
