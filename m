Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab1CVPuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 11:50:19 -0400
Received: from smtpbg52.qq.com ([64.71.138.43]:36453 "HELO smtpbg52.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932096Ab1CVPuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 11:50:14 -0400
X-QQ-mid: esmtp3t1300808894t338t15176
X-QQ-SSF: 00000000000000F0FF300F000000000
Date: Tue, 22 Mar 2011 23:48:16 +0800
From: "Lina Lu" <lulina_nuaa@foxmail.com>
To: "Vivek Goyal" <vgoyal@redhat.com>
Cc: "linux kernel mailing list" <linux-kernel@vger.kernel.org>
References: <201103201523220468314@foxmail.com>,
 <201103222332465003523@foxmail.com>
Subject: Re: Re: Re: cfq-iosched.c: panic in cfq_dispatch_requests
Message-ID: <201103222348152343383@foxmail.com>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 23:39:48, Vivek Goyal wrote:
>On Tue, Mar 22, 2011 at 11:32:47PM +0800, Lina Lu wrote:
>> On 2011-03-21 22:08:19, Vivek Goyal wrote:
>> >On Sun, Mar 20, 2011 at 03:23:23PM +0800, Lina Lu wrote:
>> >> Hi Vivek,
>> >> 
>> >> I did some test with blkio weight policy these days. The kernel panic 
>> >> once in a while. 
>> >> 	
>> >> From the calltrace, It 's in func cfq_dispatch_requests(+0x058D).
>> >> And I caught a divide by zero error with system monitor tools.
>> >
>> >Hi Lina,
>> >
>> >Can you please paste the full backtrace here.
>> >
>> >> 	
>> >> The panic happens when I first set 100 weight to two IO pids, then 
>> >> change the weight to 200, and begin to perform IO. The kernel panic
>> >> accurately when the IO begin.
>> >
>> >So you notice this only if weights are changed otherwise not?
>> 
>> Hi Vivek
>> 
>> Thanks for this patch! I did objdump and find place that divide by zero.
>> It's in cfq_group_slice function, the st->total_weight is zero in my issue.
>> As described in the patch, this is because I change the weight when the
>> group on service tree. 
>
>Ok, so this patch did solve the issue you are facing? 
>

Yes, this patch did solve the issue. 

And I will do more test these days, if there is any other problem, I will keep
you know.

Thanks
Lina


