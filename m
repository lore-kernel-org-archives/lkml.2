Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2JWBg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 21:36:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25320 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756400Ab2JWBgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 21:36:25 -0400
X-IronPort-AV: E=Sophos;i="4.80,633,1344182400"; 
   d="scan'208";a="6047313"
Message-ID: <5085F458.9080705@cn.fujitsu.com>
Date: Tue, 23 Oct 2012 09:35:20 +0800
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
 2012/10/23 09:35:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/23 09:35:54,
	Serialize complete at 2012/10/23 09:35:54
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

Hi Borislav,

As I said, cmci_rediscover() is only used to handle CPU_POST_DEAD event.
And is uses for_each_online_cpu to iterate all online cpus. If we get a
online cpu == dying, I think we are in a wrong situation. I think at
least, we should give a warning.

Thanks. :)

>
> Thanks.
>

