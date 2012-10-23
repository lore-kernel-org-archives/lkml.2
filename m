Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab2JWLbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 07:31:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25370 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab2JWLbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 07:31:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,635,1344182400"; 
   d="scan'208";a="6052302"
Message-ID: <50867FCD.9010907@cn.fujitsu.com>
Date: Tue, 23 Oct 2012 19:30:21 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, miaox@cn.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, x86@kernel.org,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in cmci_rediscover().
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com> <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com> <20121019164045.GE11958@aftab.osrc.amd.com> <5084AB10.7010807@cn.fujitsu.com> <20121022101442.GB8352@liondog.tnic> <50860711.10807@cn.fujitsu.com> <20121023095234.GA22715@liondog.tnic>
In-Reply-To: <20121023095234.GA22715@liondog.tnic>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 19:30:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 19:30:59,
	Serialize complete at 2012/10/23 19:30:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 05:52 PM, Borislav Petkov wrote:
> On Tue, Oct 23, 2012 at 10:55:13AM +0800, Tang Chen wrote:
>> So, how about warn once, and continue:
>> 	if (cpu == dying) {
>> 		WARN_ON_ONCE(cpu == dying);
>> 		continue;
>> 	}
>>
>> or, use BUG_ON() instead ?
>
> Let me ask you again, but I want you to think real hard this time:
>
> "Why do we need to warn? What good would that bring us?"

Hi,

First of all, I do think I was answering your question. As I said
before, if an online cpu == dying here, there must be something wrong.
Am I right here ?

If so, I think the "good" is obvious. If we don't output anything when
an online cpu == dying, nobody will know this happens. The kernel is in
wrong state, but nobody knows that, I don't see any good.

Actually, I used BUG_ON() in my v1 patch. So I dropped the if statement.
But Tejun asked me to use WARN_ON_ONCE(). And I forgot to add the if
statement.
Please refer to https://lkml.org/lkml/2012/10/16/528

And again, the "good" is inform user the kernel is in wrong state.

Thanks. :)


>

