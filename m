Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab0EASnh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 14:43:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:16974 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab0EASnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 14:43:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=taCXPa3ShA1VSHegFWJ6RMMd0Y4tgZHZ73WOrM5S3IDhuhqrnGZQ+3LWLGjcezoiyp
         M2JBe5nli+jRjedgGOz5k77+ezbpEtQMYSQdwxy1wurMWyaPTK7/Nv/dtQpHCa4oSZVJ
         KaaaIx/CekwfKzUgBbN2MuvBWu02cYc/6X68M=
Message-ID: <4BDC764F.7040606@gmail.com>
Date: Sat, 01 May 2010 10:43:27 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10pre) Gecko/20100422 Shredder/3.0.5pre
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Bcache: version 4
References: <20100501001212.GA31135@moria> <63479.1272718901@localhost>
In-Reply-To: <63479.1272718901@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2010 05:01 AM, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 30 Apr 2010 16:12:13 -0800, Kent Overstreet said:
>
>> Most of the basic functionality is now there; the most visible thing is
>> it's now correctly saving all the metadata, so you can unload a cache
>> and then reload it, and everything will still be there.
>
> If you unload a cache and then reload it, what prevents it from serving
> up now-stale data from an extent that was modified while the cache was
> unloaded?
>
> (Telling me "Get some caffeine, it's about halfway down in patch 2" or
> "We'll add that in Version 6 of the patch" are both acceptable answers" :)

The plan is check if any devices are open read write on cache load and 
unload, and invalidate their cached data if so. Not implemented yet, though.
