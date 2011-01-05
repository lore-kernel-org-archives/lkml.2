Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab1AESqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:46:39 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:43574 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab1AESqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:46:38 -0500
X-ASG-Debug-ID: 1294253196-178954e30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D24BC88.4090804@fusionio.com>
Date: Wed, 5 Jan 2011 19:46:32 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jerome Marchand <jmarchan@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
References: <4D0B68AF.80804@redhat.com> <4D0BB4A1.8080305@fusionio.com> <4D13664C.3020500@redhat.com> <20101223153915.GE9502@redhat.com> <4D13810B.8000304@redhat.com> <20101224192916.GB2082@redhat.com> <4D23423A.60707@redhat.com> <4D2342E1.8010405@redhat.com> <20110104210011.GB4180@kroah.com> <4D247867.9040502@fusionio.com> <20110105155816.GD2072@kroah.com>
X-ASG-Orig-Subj: Re: [PATCH 2/2] block: fix accounting bug on cross partition merges
In-Reply-To: <20110105155816.GD2072@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1294253196
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.5000 1.0000 0.0000
X-Barracuda-Spam-Score: 0.41
X-Barracuda-Spam-Status: No, SCORE=0.41 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.51520
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-05 16:58, Greg KH wrote:
> On Wed, Jan 05, 2011 at 02:55:51PM +0100, Jens Axboe wrote:
>> On 2011-01-04 22:00, Greg KH wrote:
>>> On Tue, Jan 04, 2011 at 04:55:13PM +0100, Jerome Marchand wrote:
>>>> Also add a refcount to struct hd_struct to keep the partition in
>>>> memory as long as users exist. We use kref_test_and_get() to ensure
>>>> we don't add a reference to a partition which is going away.
>>>
>>> No, don't do this, use a kref correctly and no such function should be
>>> needed.
>>>
>>>> +	} else {
>>>> +		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>>>
>>> That is the function that should properly increment the reference count
>>> on the object.  If the object is "being removed", then it will return
>>> NULL and you need to check that.  Do that and you do not need to add:
>>
>> It doesn't matter if you do it in there of after the fact, since the
>> "lock" (RCU) is being held across the call. See my original suggestion
>> here:
>>
>> https://lkml.org/lkml/2010/12/17/275
> 
> Ok, that's fine, just do it without adding that kref function and I have
> no objection :)

Why? The code is perfectly fine. I originally objected to making an API
like this for simple reference counting - seems I was right. Please
actually look at the code and use. Alexey asked whether this was a toy
API or a real one, I'd like to know that as well. If this is meant just
for very basic get/put references, fine, then document that. But then
what's the point of having this API in the first place?

-- 
Jens Axboe

