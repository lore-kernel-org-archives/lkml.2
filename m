Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2C2TnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 15:43:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61100 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab2C2TnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 15:43:16 -0400
Message-ID: <4F74BB67.30703@gmail.com>
Date: Thu, 29 Mar 2012 15:43:35 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120313 Thunderbird/11.0
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: Christoph Lameter <cl@linux.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <alpine.DEB.2.00.1203221421570.25011@router.home> <4F74A344.7070805@redhat.com>
In-Reply-To: <4F74A344.7070805@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(3/29/12 2:00 PM), Larry Woodman wrote:
> On 03/22/2012 03:30 PM, Christoph Lameter wrote:
>> On Thu, 22 Mar 2012, Larry Woodman wrote:
>>
>>>> Application may manage their locality given a range of nodes and each of
>>>> the x .. x+n nodes has their particular purpose.
>>> So to be clear on this, in that case the intention would be move 3 to 4, 4 to
>>> 5 and 5 to 6
>>> to keep the node ordering the same?
>> Yup. Have a look at do_migrate_pages and the descrition in the comment by
>> there by Paul Jackson.
>>
>>
> Christoph and others what do you think about this???
>
>
> 		for_each_node_mask(s, tmp) {
>+
>+			/* IFF there is an equal number of source and
>+			 * destination nodes, maintain relative node distance
>+			 * even when source and destination nodes overlap.
>+			 * However, when the node weight is unequal, never move
>+			 * memory out of any destination nodes */
>+			if ((nodes_weight(*from_nodes) != nodes_weight(*to_nodes)) &&
>+						(node_isset(s, *to_nodes)))
>+				continue;
>+
> 			d = node_remap(s, *from_nodes, *to_nodes);
> 			if (s == d)
> 				continue;

I'm confused. Could you please explain why you choose nodes_weight()? On my first impression,
it seems almostly unrelated factor.


