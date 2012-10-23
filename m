Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab2JWC4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:56:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:35468 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab2JWC4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:56:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,634,1344182400"; 
   d="scan'208";a="6048008"
Message-ID: <50860711.10807@cn.fujitsu.com>
Date: Tue, 23 Oct 2012 10:55:13 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd64.org>,
        tony.luck@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, miaox@cn.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in cmci_rediscover().
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com> <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com> <20121019164045.GE11958@aftab.osrc.amd.com> <5084AB10.7010807@cn.fujitsu.com> <20121022101442.GB8352@liondog.tnic>
In-Reply-To: <20121022101442.GB8352@liondog.tnic>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 10:55:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 10:55:48,
	Serialize complete at 2012/10/23 10:55:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2012 06:14 PM, Borislav Petkov wrote:
> On Mon, Oct 22, 2012 at 10:10:24AM +0800, Tang Chen wrote:
>> I don't why before we just jumped over it. But I think if we have an
>> online cpu == dying here, it must be wrong. So I think we should warn
>> it, not just jump over it.
>
> Why do we need to warn? What good would that bring us?
>
> AFAICT, the check in cmci_rediscover is there to make sure we absolutely
> don't rediscover on the dying cpu. I think it is a safety precaution in
> concurrency scenarios between cpu hotplug and mce code.

Well, I see. I dropped the if statement. :)

So, how about warn once, and continue:
	if (cpu == dying) {
		WARN_ON_ONCE(cpu == dying);
		continue;
	}

or, use BUG_ON() instead ?

>
> Thanks.
>

