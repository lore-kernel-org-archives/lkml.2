Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab1CVHgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 03:36:52 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:48891 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934Ab1CVHgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 03:36:48 -0400
X-ASG-Debug-ID: 1300779407-03d6a54f63b4b00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D88518C.80108@fusionio.com>
Date: Tue, 22 Mar 2011 08:36:44 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>
Subject: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>	 <1295659049-2688-5-git-send-email-jaxboe@fusionio.com>	 <AANLkTimEyLdYhCc7Ft4i-=us5kTVDAB5GtNOnvabhmUH@mail.gmail.com>	 <20110316173148.GC13562@redhat.com>	 <1300323609.2337.117.camel@sli10-conroe>  <4D81D7D5.7000806@fusionio.com>	 <1300430212.2337.141.camel@sli10-conroe> <4D83560E.8000002@fusionio.com>	 <4D83639A.3060407@fusionio.com> <1300690368.2337.148.camel@sli10-conroe>	 <4D87185C.4070001@fusionio.com> <1300753935.2337.149.camel@sli10-conroe>
X-ASG-Orig-Subj: Re: [PATCH 04/10] block: initial patch for on-stack per-task  plugging
In-Reply-To: <1300753935.2337.149.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300779407
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58617
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 01:32, Shaohua Li wrote:
> On Mon, 2011-03-21 at 17:20 +0800, Jens Axboe wrote:
>> On 2011-03-21 07:52, Shaohua Li wrote:
>>>> Gave it a quick test spin, as suspected it had a few issues. This one
>>>> seems to work. Can you toss it through that workload and see if it fares
>>>> better?
>>> yes, this fully restores the regression I saw. But I have accounting
>>> issue:
>>
>> Great!
>>
>>> 1. The merged request is already accounted when it's added into plug
>>> list
>>
>> Good catch. I've updated the patch and merged it now, integrating this
>> accounting fix.
>>
>>> 2. drive_stat_acct() is called without any protection in
>>> __make_request(). So there is race for in_flight accounting. The race
>>> exists after stack plug is added, so not because of this issue.
>>> Below is the extra patch I need to do the test.
>>
>> Looks fine. Can I add your signed-off-by to this patch? I'll merge it as
>> a separate fix.
> Sure.
> Signed-off-by: Shaohua Li<shaohua.li@intel.com>

Thanks, patch has been added now.

-- 
Jens Axboe

