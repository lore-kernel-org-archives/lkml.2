Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2EFPRY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 11:17:24 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36791 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934Ab2EFPRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 11:17:23 -0400
Date: Sun, 6 May 2012 23:17:15 +0800
From: Richard Yang <weiyang@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Richard Yang <weiyang@linux.vnet.ibm.com>,
        Wei Yang <weiyang.kernel@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: One problem in reassign pci bus number?
Message-ID: <20120506151715.GA7773@richard>
Reply-To: Richard Yang <weiyang@linux.vnet.ibm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWM4OTFp5NN+KOXxNREQxNWipDjWbbPPiHHJsb6yFmuiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050615-8256-0000-0000-00000244DCD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 10:37:08AM -0700, Yinghai Lu wrote:
>On Thu, May 3, 2012 at 9:52 PM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
>>
>> BTW, even if this value is returned by __find_res_top_free_size(), or
>> returned after this function is called, the purpose of the
>> __find_res_top_free_size() is to get the biggest free space under the
>> first parameter?
>
>__find_res_top_free_size() is used to get size just under top,  and
>then use it to calculate size above top that need to be extended.
>
>at last will combine free size under top and allocated size above top
>and return.
Yes, I get the general idea.

then I want to confirm which size __find_res_top_free_size() will return.

Come to the previous question, for one resource like this.
res =   90-150
    ->child      105-140
We call __find_res_top_free_size(res, 1);
This function should return which size?  10? 15? or 25?

>From the code 
+               ret = __allocate_resource(res, &tmp_res, n_size,
+                       res->end - n_size + skip_nr, res->end,
+                       1, NULL, NULL, false);
I think it will check the free space near the end of res. 

I did one test on __find_res_top_free_size(res, 1) of this example.
And returned 10. Which means, it find the free space (141-150).

So I want to confirm this function really returns the size of free space
at the end of the res. not the biggest one or the sum.
>
>Yinghai

-- 
Richard Yang
Help you, Help me

