Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab2FKKRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:17:44 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46831 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab2FKKRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:17:42 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 15/16] hugetlb/cgroup: migrate hugetlb cgroup info from oldpage to new page during migration
In-Reply-To: <20120611092424.GJ12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120611092424.GJ12402@tiehlicka.suse.cz>
User-Agent: Notmuch/0.13.2+35~g0ff57e7 (http://notmuchmail.org) Emacs/24.1.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 11 Jun 2012 15:47:28 +0530
Message-ID: <878vfu5f0n.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12061023-5490-0000-0000-00000191F883
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Sat 09-06-12 14:30:00, Aneesh Kumar K.V wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>> 
>> With HugeTLB pages, hugetlb cgroup is uncharged in compound page
>> destructor.  Since we are holding a hugepage reference,
>
> Who is holding that reference? I do not see anybody calling get_page in
> this patch...
>

soft_offline_huge_page takes the reference. It does the final
put_page(hpage) there.

>> we can be sure that old page won't get uncharged till the last
>> put_page().
>> 

-aneesh

