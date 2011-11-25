Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1KYKBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:01:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab1KYKBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:01:48 -0500
Message-ID: <4ECF680C.7060606@redhat.com>
Date: Fri, 25 Nov 2011 18:03:56 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kexec: do not call kmsg_dump in crashdump
References: <20111125081959.GA2505@darkstar.nay.redhat.com> <CAM_iQpW7WXeUihgbJneJUJ1GAMzXfONfV69dpqeRbUt_781M=Q@mail.gmail.com>
In-Reply-To: <CAM_iQpW7WXeUihgbJneJUJ1GAMzXfONfV69dpqeRbUt_781M=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2011 05:32 PM, Cong Wang wrote:

> On Fri, Nov 25, 2011 at 4:19 PM, Dave Young <dyoung@redhat.com> wrote:
>> mtd/ram oops dumper will make more functions envolved. In case crash kexec,
>> we should avoid kmsg dumper to ensure crashdump success.
>>
>> kill kmsg_dump callback while crash dumping
> 
> https://lkml.org/lkml/2011/2/1/33


Thanks for give the link. So it's intend to be that.

I'm still confused with the KMSG_DUMP_KEXEC.

crash_kexec()
	kmsg_dump(KMSG_DUMP_KEXEC)
kmsg_dump(KMSG_DUMP_PANIC)

Looks like it's equal to original logic, isn't it?

kmsg_dump(anything);
crash_kexec()

So why intruduce KMSG_DUMP_KEXEC? why not just kmsg_dump before crash_kexec?

thoughts?

-- 
Thanks
Dave
