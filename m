Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab1KXDQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:16:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1KXDQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:16:18 -0500
Message-ID: <4ECDB6E6.40304@redhat.com>
Date: Thu, 24 Nov 2011 11:15:50 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mm@kvack.org
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
References: <1322038412-29013-1-git-send-email-amwang@redhat.com> <CAHGf_=rOYkEGHakyHpihopMg2VtVfDV7XvC_QGs_kj6HgDmBRA@mail.gmail.com> <CAOJsxLH2foaRHYoPgRufu_J8B-YEvQ8aJNuQqHOPNj9YFvAubw@mail.gmail.com> <alpine.LSU.2.00.1111231407170.2573@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1111231407170.2573@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月24日 06:20, Hugh Dickins 写道:
> On Wed, 23 Nov 2011, Pekka Enberg wrote:
>>
>> Why do we need to undo anyway?
...
> Another answer would be: if fallocate() had been defined to return
> the length that has been successfully allocated (as write() returns
> the length written), then it would be reasonable to return partial
> length instead of failing with ENOSPC, and not undo.  But it was
> defined to return -1 on failure or 0 on success, so cannot report
> partial success.
>
> Another answer would be: if the disk is near full, it's not good
> for a fallocate() to fail with -ENOSPC while nonetheless grabbing
> all the remaining blocks; even worse if another fallocate() were
> racing with it.

Exactly, fallocate() should not make the bad situation even worse.

Thanks.
