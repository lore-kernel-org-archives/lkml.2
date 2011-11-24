Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1KXDSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:18:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab1KXDSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:18:39 -0500
Message-ID: <4ECDB778.30006@redhat.com>
Date: Thu, 24 Nov 2011 11:18:16 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
References: <1322038412-29013-1-git-send-email-amwang@redhat.com> <alpine.LSU.2.00.1111231100110.2226@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1111231100110.2226@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月24日 03:07, Hugh Dickins 写道:
> On Wed, 23 Nov 2011, Cong Wang wrote:
>> +
>> +	while (index<  end) {
>> +		ret = shmem_getpage(inode, index,&page, SGP_WRITE, NULL);
>> +		if (ret) {
>> +			if (ret == -ENOSPC)
>> +				goto undo;
> ...
>> +undo:
>> +	while (index>  start) {
>> +		shmem_truncate_page(inode, index);
>> +		index--;
>> +	}
>
> As I said before, I won't actually be reviewing and testing this for
> a week or two; but before this goes any further, must point out how
> wrong it is.  Here you'll be deleting any pages in the range that were
> already present before the failing fallocate().

Ah, I totally missed this. So, is there any way to tell if the page
gotten from shmem_getpage() is newly allocated or not?

I will dig the code...

Thanks.
