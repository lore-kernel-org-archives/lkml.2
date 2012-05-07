Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2EGBRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 21:17:39 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:47969 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2EGBRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 21:17:38 -0400
Date: Mon, 7 May 2012 09:17:22 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>,
        Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120507011722.GA8122@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
References: <CAE9FiQXLxEEu68tJvph3LB53nqycK+YctwDKMEF824koXVM5AA@mail.gmail.com>
 <20120503065455.GA30042@richard>
 <CAE9FiQUVNA_jdRfsSR9Rv47aa6JX-HKET0z3SfK19wT=Fcd9Cg@mail.gmail.com>
 <20120504024721.GA6775@richard>
 <CAE9FiQUz2w815gU5vY5b0BPf+1pz_pafgzqVKizJC++z27RTaQ@mail.gmail.com>
 <20120504045205.GA21624@richard>
 <CAE9FiQWM4OTFp5NN+KOXxNREQxNWipDjWbbPPiHHJsb6yFmuiQ@mail.gmail.com>
 <20120506151715.GA7773@richard>
 <CAE9FiQWsSWK-_zGe1ggaKuZu+RJ1kb1zuTEokdxqFSbE3UjNRw@mail.gmail.com>
 <CAE9FiQXKjxLDLeh8TXU_OCNwFt+UMv3qFjcPrKcPcorA1YmkdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQXKjxLDLeh8TXU_OCNwFt+UMv3qFjcPrKcPcorA1YmkdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050615-1396-0000-0000-0000011A344F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 09:36:35AM -0700, Yinghai Lu wrote:
>On Sun, May 6, 2012 at 9:35 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sun, May 6, 2012 at 8:17 AM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
>>> On Fri, May 04, 2012 at 10:37:08AM -0700, Yinghai Lu wrote:
>>>>On Thu, May 3, 2012 at 9:52 PM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
>>>>>
>>>>> BTW, even if this value is returned by __find_res_top_free_size(), or
>>>>> returned after this function is called, the purpose of the
>>>>> __find_res_top_free_size() is to get the biggest free space under the
>>>>> first parameter?
>>>>
>>>>__find_res_top_free_size() is used to get size just under top,  and
>>>>then use it to calculate size above top that need to be extended.
>>>>
>>>>at last will combine free size under top and allocated size above top
>>>>and return.
>>> Yes, I get the general idea.
>>>
>>> then I want to confirm which size __find_res_top_free_size() will return.
>>>
>>> Come to the previous question, for one resource like this.
>>> res =   90-150
>>>    ->child      105-140
>>> We call __find_res_top_free_size(res, 1);
>>> This function should return which size?  10? 15? or 25?
>>>
>>> From the code
>>> +               ret = __allocate_resource(res, &tmp_res, n_size,
>>> +                       res->end - n_size + skip_nr, res->end,
>>> +                       1, NULL, NULL, false);
>>> I think it will check the free space near the end of res.
>>
>> yes. it is 15, [141-150]
>
>should 10, aka [141-150]
Thanks, 
so this free space will be combined with the free space got from
parent, form a big space to meet the requirement.

This is the general idea about probe_resource()?

And this is the design decision to find the free space at the end 
of top, even at the start we have more free space?

-- 
Richard Yang
Help you, Help me

