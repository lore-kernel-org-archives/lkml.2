Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab0DOKV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:21:29 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:53435 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab0DOKV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:21:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hGibmkuQfIgDOqQE8+gYmIOPxPgo3/H9lOaNKoJEZjla9sMoGjRYuL4tYrEAUZ9jVR
         qJzXNx8e2SdgpexUxy1AAGXxPOzUD2pqjiZ9MdeXE6sAP0oj/09P+vsG/cWuLcKeAX7r
         +pfHY/Z25Fo3jKwttOn6KUcurObNIlBzG+Hl0=
MIME-Version: 1.0
In-Reply-To: <4BC6E581.1000604@kernel.org>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <d5d70d4b57376bc89f178834cf0e424eaa681ab4.1271171877.git.minchan.kim@gmail.com>
	 <20100413154820.GC25756@csn.ul.ie> <4BC65237.5080408@kernel.org>
	 <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
	 <4BC6BE78.1030503@kernel.org>
	 <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>
	 <4BC6CB30.7030308@kernel.org>
	 <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>
	 <4BC6E581.1000604@kernel.org>
Date: Thu, 15 Apr 2010 19:21:22 +0900
Message-ID: <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
Subject: Re: [PATCH 2/6] change alloc function in pcpu_alloc_pages
From: Minchan Kim <minchan.kim@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 7:08 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 04/15/2010 06:40 PM, Minchan Kim wrote:
>>> I'm not an expert on that part of the kernel but isn't
>>> alloc_pages_any_node() identical to alloc_pages_exact_node()?  All
>>
>> alloc_pages_any_node means user allows allocated pages in any
>> node(most likely current node) alloc_pages_exact_node means user
>> allows allocated pages in nid node if he doesn't use __GFP_THISNODE.
>
> Ooh, sorry, I meant alloc_pages().  What would be the difference
> between alloc_pages_any_node() and alloc_pages()?

It's no different. It's same. Just naming is more explicit. :)
I think it could be following as.

#define alloc_pages alloc_pages_any_node.
strucdt page * alloc_pages_node() {
   int nid = numa_node_id();
   ...
   return page;
}

>
>>> introducing new API just to weed out invalid usages seems like an
>>> overkill.
>>
>> It might be.
>>
>> It think it's almost same add_to_page_cache and add_to_page_cache_locked.
>> If user knows the page is already locked, he can use
>> add_to_page_cache_locked for performance gain and code readability
>> which we need to lock the page before calling it.
>
> Yeah, if both APIs are necessary at the end of the conversion, sure.
> I was just saying that introducing new APIs just to weed out invalid
> usages and then later killing the old API would be rather excessive.
>
> I was just wondering whether we could just clean up alloc_pages_node()
> users and kill alloc_pages_exact_node().

kill alloc_pages_exact_node?
Sorry but I can't understand your point.
I don't want to kill user of alloc_pages_exact_node.
That's opposite.
I want to kill user of alloc_pages_node and change it with
alloc_pages_any_node or alloc_pages_exact_node. :)

I think we can do it. That's because all of caller already can check nid == -1
before calling allocation function explicitly if he cares node locality.

-- 
Kind regards,
Minchan Kim
