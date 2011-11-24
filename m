Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab1KXCrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 21:47:03 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54239 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1KXCrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 21:47:01 -0500
MIME-Version: 1.0
In-Reply-To: <20111124105245.b252c65f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1322038412-29013-1-git-send-email-amwang@redhat.com> <20111124105245.b252c65f.kamezawa.hiroyu@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 23 Nov 2011 21:46:39 -0500
X-Google-Sender-Auth: rYvgiJLGw-wJv2Yd0Ux6eKiPqDk
Message-ID: <CAHGf_=oD0Coc=k5kAAQoP=GqK+nc0jd3qq3TmLZaitSjH-ZPmQ@mail.gmail.com>
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     while (index < end) {
>> +             ret = shmem_getpage(inode, index, &page, SGP_WRITE, NULL);
>
> If the 'page' for index exists before this call, this will return the page without
> allocaton.
>
> Then, the page may not be zero-cleared. I think the page should be zero-cleared.

No. fallocate shouldn't destroy existing data. It only ensure
subsequent file access don't make ENOSPC error.
