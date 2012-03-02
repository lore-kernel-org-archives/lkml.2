Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2CBFUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 00:20:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:26224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2CBFUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 00:20:09 -0500
X-IronPort-AV: E=Sophos;i="4.73,516,1325433600"; 
   d="scan'208";a="4430850"
Message-ID: <4F505937.9080904@cn.fujitsu.com>
Date: Fri, 02 Mar 2012 13:23:03 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v2 1/3] xattr: extract kmem_xattr code from tmpfs
References: <4F4F1459.4080300@cn.fujitsu.com>	<4F4F146C.9090300@cn.fujitsu.com> <CAJd=RBB+2r-Q8K1FQqPh90EdtAdmz3R8FWU48M_ePqyziNfcLw@mail.gmail.com>
In-Reply-To: <CAJd=RBB+2r-Q8K1FQqPh90EdtAdmz3R8FWU48M_ePqyziNfcLw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-02 13:18:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-02 13:18:16,
	Serialize complete at 2012-03-02 13:18:16
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hillf Danton wrote:
> On Thu, Mar 1, 2012 at 2:17 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> +/*
>> + * free all the xattrs
>> + */
>> +void kmem_xattrs_free(struct kmem_xattrs *xattrs)
>> +{
>> +       struct kmem_xattr *xattr, *node;
>> +
>> +       spin_lock(&xattrs->lock);
>> +       list_for_each_entry_safe(xattr, node, &xattrs->head, list) {
>> +               kfree(xattr->name);
>> +               kfree(xattr);
>> +       }
>> +       spin_unlock(&xattrs->lock);
> 
> In your work it is a library function, operations on &xattrs->head
> are no longer allowed, say list_empty(), after it called, though I
> dunno if such operations exist.
> 

I'd prefer to make it safer to use, so I'll re-init the list head
after freeing all the list items.

> And kmem_xattrs is too close to kmem_xattr, kmem_xattr_list
> is not pron of typo.
> 

Then you won't pass compile. ;)

kmem_xattr_list exposed the data structure we used internally.
We might change to use an rbtree.
