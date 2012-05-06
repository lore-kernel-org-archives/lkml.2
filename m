Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab2EFQgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 12:36:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59485 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2EFQgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 12:36:36 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWsSWK-_zGe1ggaKuZu+RJ1kb1zuTEokdxqFSbE3UjNRw@mail.gmail.com>
References: <20120422155202.GA13540@richard>
	<CAE9FiQXoUcUw5kOcBmsbBu_hJ+GbKk--qFt+WyUHbjJPwY+8Pw@mail.gmail.com>
	<CADLM8XPryGVVWVruB=sZ9zxPp-nEhz8xKeMhY3u8KBShk2suBQ@mail.gmail.com>
	<CAE9FiQXLxEEu68tJvph3LB53nqycK+YctwDKMEF824koXVM5AA@mail.gmail.com>
	<20120503065455.GA30042@richard>
	<CAE9FiQUVNA_jdRfsSR9Rv47aa6JX-HKET0z3SfK19wT=Fcd9Cg@mail.gmail.com>
	<20120504024721.GA6775@richard>
	<CAE9FiQUz2w815gU5vY5b0BPf+1pz_pafgzqVKizJC++z27RTaQ@mail.gmail.com>
	<20120504045205.GA21624@richard>
	<CAE9FiQWM4OTFp5NN+KOXxNREQxNWipDjWbbPPiHHJsb6yFmuiQ@mail.gmail.com>
	<20120506151715.GA7773@richard>
	<CAE9FiQWsSWK-_zGe1ggaKuZu+RJ1kb1zuTEokdxqFSbE3UjNRw@mail.gmail.com>
Date: Sun, 6 May 2012 09:36:35 -0700
X-Google-Sender-Auth: HBBEfTkAHzPE0Ro71o_3E31RlD4
Message-ID: <CAE9FiQXKjxLDLeh8TXU_OCNwFt+UMv3qFjcPrKcPcorA1YmkdQ@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 6, 2012 at 9:35 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sun, May 6, 2012 at 8:17 AM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
>> On Fri, May 04, 2012 at 10:37:08AM -0700, Yinghai Lu wrote:
>>>On Thu, May 3, 2012 at 9:52 PM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
>>>>
>>>> BTW, even if this value is returned by __find_res_top_free_size(), or
>>>> returned after this function is called, the purpose of the
>>>> __find_res_top_free_size() is to get the biggest free space under the
>>>> first parameter?
>>>
>>>__find_res_top_free_size() is used to get size just under top,  and
>>>then use it to calculate size above top that need to be extended.
>>>
>>>at last will combine free size under top and allocated size above top
>>>and return.
>> Yes, I get the general idea.
>>
>> then I want to confirm which size __find_res_top_free_size() will return.
>>
>> Come to the previous question, for one resource like this.
>> res =   90-150
>>    ->child      105-140
>> We call __find_res_top_free_size(res, 1);
>> This function should return which size?  10? 15? or 25?
>>
>> From the code
>> +               ret = __allocate_resource(res, &tmp_res, n_size,
>> +                       res->end - n_size + skip_nr, res->end,
>> +                       1, NULL, NULL, false);
>> I think it will check the free space near the end of res.
>
> yes. it is 15, [141-150]

should 10, aka [141-150]
