Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2ELWV3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 18:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab2ELWV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 18:21:28 -0400
Message-ID: <4FAEE256.7000403@redhat.com>
Date: Sat, 12 May 2012 18:21:10 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Satoru Moriya <satoru.moriya@hds.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "jweiner@redhat.com" <jweiner@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [RFC][PATCH] avoid swapping out with swappiness==0
References: <65795E11DBF1E645A09CEC7EAEE94B9CB9455FE2@USINDEVS02.corp.hds.com> <20120305215602.GA1693@redhat.com> <4F5798B1.5070005@jp.fujitsu.com> <65795E11DBF1E645A09CEC7EAEE94B9CB951A45F@USINDEVS02.corp.hds.com> <65795E11DBF1E645A09CEC7EAEE94B9C01454D13A6@USINDEVS02.corp.hds.com> <CAHGf_=p9OgVC9J-Nh78CTbuMbc9CVt-+-G+CNbYUsgz70Uc8Qg@mail.gmail.com> <4F7ADE1A.2050004@redhat.com> <4F7C870B.6020807@gmail.com> <65795E11DBF1E645A09CEC7EAEE94B9C014575D8CF@USINDEVS02.corp.hds.com> <65795E11DBF1E645A09CEC7EAEE94B9C01583B4D7C@USINDEVS02.corp.hds.com>
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9C01583B4D7C@USINDEVS02.corp.hds.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 05:11 PM, Satoru Moriya wrote:
> On 04/20/2012 08:21 PM, Satoru Moriya wrote:
>> Ah yes, it is not so small now.
>> On 4GB server, without THP min_free_kbytes is 8113 but with THP it is
>> 67584.
>>
>> How about using low watermark or min watermark?
>> Are they still big?
>>
>> ...or should we use other value?
>
> What do you think of the idea above?

I believe that using the high watermark is just fine.

We want to start swapping, before the page cache is so
small that we start thrashing from that.

> So, I propose that we start with applying this patch first
> and then discuss/improve the threshold.
>
> The patch may not be perfect but, at least, we can improve
> the kernel behavior in the enough filebacked memory case
> with this patch. I believe it's better than nothing.

Agreed.

-- 
All rights reversed
