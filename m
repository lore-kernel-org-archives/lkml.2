Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686Ab2JZHDY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:03:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58031 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab2JZHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:03:22 -0400
Message-ID: <508A35B0.30106@gmail.com>
Date: Fri, 26 Oct 2012 15:03:12 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Dave Chinner <david@fromorbit.com>, YingHang Zhu <casualfisher@gmail.com>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: remove redundant ra_pages in file_ra_state
References: <CAA9v8mGjdi9Kj7p-yeLJx-nr8C+u4M=QcP5+WcA+5iDs6-thGw@mail.gmail.com> <20121024201921.GX4291@dastard> <CAA9v8mExDX1TYgCrRfYuh82SnNmNkqC4HjkmczSnz3Ca4zT_qw@mail.gmail.com> <20121025015014.GC29378@dastard> <CAA9v8mEULAEHn8qSsFokEue3c0hy8pK8bkYB+6xOtz_Tgbp0vw@mail.gmail.com> <50889FF1.9030107@gmail.com> <20121025025826.GB23462@localhost> <20121026002544.GI29378@dastard> <20121026012758.GA6282@localhost> <5089F5AD.5040708@gmail.com> <20121026065855.GA9179@localhost>
In-Reply-To: <20121026065855.GA9179@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 02:58 PM, Fengguang Wu wrote:
>>   static void shrink_readahead_size_eio(struct file *filp,
>>                                          struct file_ra_state *ra)
>>   {
>> -       ra->ra_pages /= 4;
>> +       spin_lock(&filp->f_lock);
>> +       filp->f_mode |= FMODE_RANDOM;
>> +       spin_unlock(&filp->f_lock);
>>
>> As the example in comment above this function, the read maybe still
>> sequential, and it will waste IO bandwith if modify to FMODE_RANDOM
>> directly.
> Yes immediately disabling readahead may hurt IO performance, the
> original '/ 4' may perform better when there are only 1-3 IO errors
> encountered.

Hi Fengguang,

Why the number should be 1-3?

Regards,
Chen

>
> Thanks,
> Fengguang
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

