Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab2C1DnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 23:43:04 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34353 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579Ab2C1DnC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 23:43:02 -0400
MIME-Version: 1.0
In-Reply-To: <20120327151238.302a5920.akpm@linux-foundation.org>
References: <1332805767-2013-1-git-send-email-consul.kautuk@gmail.com>
	<20120327151238.302a5920.akpm@linux-foundation.org>
Date: Wed, 28 Mar 2012 09:13:00 +0530
Message-ID: <CAFPAmTR67R6aF9U7-idXGDsbfvhTxEn=D3pu_Jjhq37rhcez8Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mmap.c: find_vma: remove if(mm) check
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 3:42 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 26 Mar 2012 19:49:27 -0400
> Kautuk Consul <consul.kautuk@gmail.com> wrote:
>
>> find_vma is called from kernel code where it is absolutely
>> sure that the mm_struct arg being passed to it is non-NULL.
>>
>> Remove the if(mm) check.
>
> It's odd that the if(mm) test exists - I wonder why it was originally
> added.  My repo only goes back ten years, and it's there in 2.4.18.
>
> Any code which calls find_vma() without an mm is surely pretty busted?
>
>
> Still, I think I'd prefer to do
>
>        if (WARN_ON_ONCE(!mm))
>                return NULL;
>

yes, I agree. that is safe for now as there are a huge number of calls
to this API.

> then let that bake for a kernel release, just to find out if we have a
> weird caller out there, such as a function which is called by both user
> threads and by kernel threads.

ok. I'll spin another one and send it to you with your suggestions in a day or
two when I go back home after my day job.
