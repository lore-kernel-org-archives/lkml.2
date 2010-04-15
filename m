Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab0DOKdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:33:32 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60794 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab0DOKd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SJAPMwgXv8P127RhnRy7ivPAkkdiEKeL6Q/YTQa59dSpkZuFD4co1KdHD9JlobgJJe
         dciWr+nhDjb0ZNGy2hnro0ml/CI3BfirMeb0rThUL8iBCXxvgNaOJSHbU+a/W6DiU8AT
         qohNEfQeqV2MWY9Y/u0MexzeqdZHPl5Utp1Gs=
MIME-Version: 1.0
In-Reply-To: <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <20100413154820.GC25756@csn.ul.ie> <4BC65237.5080408@kernel.org>
	 <v2j28c262361004141831h8f2110d5pa7a1e3063438cbf8@mail.gmail.com>
	 <4BC6BE78.1030503@kernel.org>
	 <h2w28c262361004150100ne936d943u28f76c0f171d3db8@mail.gmail.com>
	 <4BC6CB30.7030308@kernel.org>
	 <l2u28c262361004150240q8a873b6axb73eaa32fd6e65e6@mail.gmail.com>
	 <4BC6E581.1000604@kernel.org>
	 <z2p28c262361004150321sc65e84b4w6cc99927ea85a52b@mail.gmail.com>
Date: Thu, 15 Apr 2010 19:33:28 +0900
Message-ID: <n2i28c262361004150333nf1bac78dr13acc418496e6a6b@mail.gmail.com>
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

On Thu, Apr 15, 2010 at 7:21 PM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Thu, Apr 15, 2010 at 7:08 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> On 04/15/2010 06:40 PM, Minchan Kim wrote:
>>>> I'm not an expert on that part of the kernel but isn't
>>>> alloc_pages_any_node() identical to alloc_pages_exact_node()?  All
>>>
>>> alloc_pages_any_node means user allows allocated pages in any
>>> node(most likely current node) alloc_pages_exact_node means user
>>> allows allocated pages in nid node if he doesn't use __GFP_THISNODE.
>>
>> Ooh, sorry, I meant alloc_pages().  What would be the difference
>> between alloc_pages_any_node() and alloc_pages()?
>
> It's no different. It's same. Just naming is more explicit. :)
> I think it could be following as.
>
> #define alloc_pages alloc_pages_any_node.
> strucdt page * alloc_pages_node() {
typo. Sorry.
struct page * alloc_pages_any_node {

>   int nid = numa_node_id();
>   ...
>   return page;
> }
>


-- 
Kind regards,
Minchan Kim
