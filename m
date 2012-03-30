Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241Ab2C3Ra4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:30:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756560Ab2C3Rav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:30:51 -0400
Message-ID: <4F75EDC3.7050104@redhat.com>
Date: Fri, 30 Mar 2012 13:30:43 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <alpine.DEB.2.00.1203221421570.25011@router.home> <4F74A344.7070805@redhat.com> <4F74BB67.30703@gmail.com> <alpine.DEB.2.00.1203301113530.22502@router.home>
In-Reply-To: <alpine.DEB.2.00.1203301113530.22502@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 12:15 PM, Christoph Lameter wrote:
> On Thu, 29 Mar 2012, KOSAKI Motohiro wrote:
>
>>> 		for_each_node_mask(s, tmp) {
>>> +
>>> +			/* IFF there is an equal number of source and
>>> +			 * destination nodes, maintain relative node distance
>>> +			 * even when source and destination nodes overlap.
>>> +			 * However, when the node weight is unequal, never
>>> move
>>> +			 * memory out of any destination nodes */
>>> +			if ((nodes_weight(*from_nodes) !=
>>> nodes_weight(*to_nodes))&&
>>> +						(node_isset(s, *to_nodes)))
>>> +				continue;
>>> +
>>> 			d = node_remap(s, *from_nodes, *to_nodes);
>>> 			if (s == d)
>>> 				continue;
>> I'm confused. Could you please explain why you choose nodes_weight()? On my
>> first impression,
>> it seems almostly unrelated factor.
> Isnt this the original code by Paul?
No, I added the test to see if the source and destination has the same 
number of nodes.
>   I would think that the 1-1 movement
> is only useful to do if the number of nodes in both the destination and
> the source is the same.
Agreed, thats exactly what this patch does.  are you OK with this change 
then???

Larry


