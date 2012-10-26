Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2JZIIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:08:31 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58188 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110Ab2JZII0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:08:26 -0400
Message-ID: <508A44F0.4080606@gmail.com>
Date: Fri, 26 Oct 2012 16:08:16 +0800
From: Ni zhan Chen <nizhan.chen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Dave Chinner <david@fromorbit.com>, YingHang Zhu <casualfisher@gmail.com>,
        akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: readahead: remove redundant ra_pages in file_ra_state
References: <20121025025826.GB23462@localhost> <20121026002544.GI29378@dastard> <20121026012758.GA6282@localhost> <5089F5AD.5040708@gmail.com> <20121026065855.GA9179@localhost> <508A35B0.30106@gmail.com> <20121026070936.GA12282@localhost> <508A399D.6000506@gmail.com> <20121026073630.GA12886@localhost> <508A4007.5080906@gmail.com> <20121026080240.GA13662@localhost>
In-Reply-To: <20121026080240.GA13662@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 04:02 PM, Fengguang Wu wrote:
> On Fri, Oct 26, 2012 at 03:47:19PM +0800, Ni zhan Chen wrote:
>> On 10/26/2012 03:36 PM, Fengguang Wu wrote:
>>> On Fri, Oct 26, 2012 at 03:19:57PM +0800, Ni zhan Chen wrote:
>>>> On 10/26/2012 03:09 PM, Fengguang Wu wrote:
>>>>> On Fri, Oct 26, 2012 at 03:03:12PM +0800, Ni zhan Chen wrote:
>>>>>> On 10/26/2012 02:58 PM, Fengguang Wu wrote:
>>>>>>>>   static void shrink_readahead_size_eio(struct file *filp,
>>>>>>>>                                          struct file_ra_state *ra)
>>>>>>>>   {
>>>>>>>> -       ra->ra_pages /= 4;
>>>>>>>> +       spin_lock(&filp->f_lock);
>>>>>>>> +       filp->f_mode |= FMODE_RANDOM;
>>>>>>>> +       spin_unlock(&filp->f_lock);
>>>>>>>>
>>>>>>>> As the example in comment above this function, the read maybe still
>>>>>>>> sequential, and it will waste IO bandwith if modify to FMODE_RANDOM
>>>>>>>> directly.
>>>>>>> Yes immediately disabling readahead may hurt IO performance, the
>>>>>>> original '/ 4' may perform better when there are only 1-3 IO errors
>>>>>>> encountered.
>>>>>> Hi Fengguang,
>>>>>>
>>>>>> Why the number should be 1-3?
>>>>> The original behavior is '/= 4' on each error.
>>>>>
>>>>> After 1 errors, readahead size will be shrinked by 1/4
>>>>> After 2 errors, readahead size will be shrinked by 1/16
>>>>> After 3 errors, readahead size will be shrinked by 1/64
>>>>> After 4 errors, readahead size will be effectively 0 (disabled)
>>>> But from function shrink_readahead_size_eio and its caller
>>>> filemap_fault I can't find the behavior you mentioned. How you
>>>> figure out it?
>>> It's this line in shrink_readahead_size_eio():
>>>
>>>          ra->ra_pages /= 4;
>> Yeah, I mean why the 4th readahead size will be 0(disabled)? What's
>> the original value of ra->ra_pages? How can guarantee the 4th shrink
>> readahead size can be 0?
> Ah OK, I'm talking about the typical case. The default readahead size
> is 128k, which will become 0 after / 256. The reasonable good ra size
> for hard disks is 1MB=256pages, which also becomes 1page after 4 errors.

Then why default size is not set to reasonable size?

Regards,
Chen

>
> Thanks,
> Fengguang
>

