Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab2CVSss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:48:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2CVSsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:48:47 -0400
Message-ID: <4F6B73AD.5050107@redhat.com>
Date: Thu, 22 Mar 2012 14:47:09 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: lwoodman@redhat.com, Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com>
In-Reply-To: <4F6B7358.60800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 02:45 PM, KOSAKI Motohiro wrote:
> CC to Christoph.
>
>> While moving tasks between cpusets I noticed some strange behavior.
>> Specifically if the nodes of the destination
>> cpuset are a subset of the nodes of the source cpuset
>> do_migrate_pages() will move pages that are already on a node
>> in the destination cpuset. The reason for this is do_migrate_pages()
>> does not check whether each node in the source
>> nodemask is in the destination nodemask before calling
>> migrate_to_node(). If we simply do this check and skip them
>> when the source is in the destination moving we wont move nodes that
>> dont need to be moved.
>>
>> Adding a little debug printk to migrate_to_node():
>>
>> Without this change migrating tasks from a cpuset containing nodes 0-7
>> to a cpuset containing nodes 3-4, we migrate
>> from ALL the nodes even if they are in the both the source and
>> destination nodesets:
>>
>> Migrating 7 to 4
>> Migrating 6 to 3
>> Migrating 5 to 4
>> Migrating 4 to 3
>> Migrating 1 to 4
>> Migrating 3 to 4
>> Migrating 0 to 3
>> Migrating 2 to 3
>
> Wait.
>
> This may be non-optimal for cpusets, but maybe optimal migrate_pages,
> especially
> the usecase is HPC. I guess this is intended behavior. I think we need
> to hear
> Christoph's intention.

How is the moving of pages that are already in the
intended cpuset better than just leaving them alone?

> But, I'm not against this if he has no objection.

Sure. Christoph?
