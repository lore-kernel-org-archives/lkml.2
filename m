Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab1KWVL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:11:29 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64963 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab1KWVL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:11:28 -0500
MIME-Version: 1.0
In-Reply-To: <CAHGf_=rOYkEGHakyHpihopMg2VtVfDV7XvC_QGs_kj6HgDmBRA@mail.gmail.com>
References: <1322038412-29013-1-git-send-email-amwang@redhat.com>
	<CAHGf_=rOYkEGHakyHpihopMg2VtVfDV7XvC_QGs_kj6HgDmBRA@mail.gmail.com>
Date: Wed, 23 Nov 2011 23:11:26 +0200
X-Google-Sender-Auth: yjO253lXgLQwq6ydbcgCQPgPMjI
Message-ID: <CAOJsxLH2foaRHYoPgRufu_J8B-YEvQ8aJNuQqHOPNj9YFvAubw@mail.gmail.com>
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 9:59 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> +
>> +       goto unlock;
>> +
>> +undo:
>> +       while (index > start) {
>> +               shmem_truncate_page(inode, index);
>> +               index--;
>
> Hmmm...
> seems too aggressive truncate if the file has pages before starting fallocate.
> but I have no idea to make better undo. ;)

Why do we need to undo anyway?

                                Pekka
