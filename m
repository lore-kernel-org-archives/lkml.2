Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab1KBRTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 13:19:12 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42513 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab1KBRTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 13:19:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDdirdNiPMVcYLNFO5Ho+pRGCfh_RRA7_re+76Ds+H0pw@mail.gmail.com>
References: <CALCETrW1mpVCz2tO5roaz1r6vnno+srHR-dHA6_pkRi2qiCfdw@mail.gmail.com>
 <CAJd=RBDdirdNiPMVcYLNFO5Ho+pRGCfh_RRA7_re+76Ds+H0pw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 2 Nov 2011 10:18:50 -0700
Message-ID: <CALCETrVL3MUMh2kDPaZ6Z9Lz=eWas_dF0jwWMiF3KvNUcJKXJw@mail.gmail.com>
Subject: Re: hugetlb oops on 3.1.0-rc8-devel
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 5:06 AM, Hillf Danton <dhillf@gmail.com> wrote:
> On Wed, Nov 2, 2011 at 6:20 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> The line that crashed is BUG_ON(page_count(old_page) != 1) in hugetlb_cow.
>>
>
> Hello Andy
>
> Would you please try the following patch?
>
> Thanks
>        Hillf
>
>
> --- a/mm/hugetlb.c      Sat Aug 13 11:45:14 2011
> +++ b/mm/hugetlb.c      Wed Nov  2 20:12:00 2011
> @@ -2422,6 +2422,8 @@ retry_avoidcopy:
>         * anon_vma prepared.
>         */
>        if (unlikely(anon_vma_prepare(vma))) {
> +               page_cache_release(new_page);
> +               page_cache_release(old_page);
>                /* Caller expects lock to be held */
>                spin_lock(&mm->page_table_lock);
>                return VM_FAULT_OOM;
>

I'll patch it in.  My test case took over a week to hit it once, so I
can't guarantee I'll spot it.

--Andy
