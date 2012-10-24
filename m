Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934214Ab2JXCAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:00:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab2JXCAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:00:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,638,1344182400"; 
   d="scan'208";a="6054846"
Message-ID: <508744ED.2040002@cn.fujitsu.com>
Date: Wed, 24 Oct 2012 09:31:25 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] Replace if statement with WARN_ON_ONCE() in cmci_rediscover().
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com> <1350625528-1385-2-git-send-email-tangchen@cn.fujitsu.com> <20121019164045.GE11958@aftab.osrc.amd.com> <5084AB10.7010807@cn.fujitsu.com> <20121022101442.GB8352@liondog.tnic> <50860711.10807@cn.fujitsu.com> <20121023095234.GA22715@liondog.tnic> <50867FCD.9010907@cn.fujitsu.com> <3908561D78D1C84285E8C5FCA982C28F19D58D8E@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D58D8E@ORSMSX108.amr.corp.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 09:31:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/24 09:32:45,
	Serialize complete at 2012/10/24 09:32:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luck, Borislav,

OK, since you all think it is not necessary, I think I will drop patch1.
And thanks for your comments. :)

So, how about patch2 ?
If you need more detail, please tell me. Thanks. :)

On 10/24/2012 12:16 AM, Luck, Tony wrote:
>> First of all, I do think I was answering your question. As I said
>> before, if an online cpu == dying here, there must be something wrong.
>> Am I right here ?
>
> Yes - but there is a fuzzy line over where it is good to check for "something wrong"
> or whether to trust that the caller of the function knew what they were doing.
>
> For example we trust that "dying" is a valid cpu number.  If we were
> super-paranoid that someone might change the code and call us with a
> bad argument, we might add:
>
> 	BUG_ON(dying<  0 || dying>= MAX_NR_CPUS);
>
> This would certainly help debug the case if someone did make a bogus
> change ... but I think it is clear that this test is way past the fuzzy line and
> into pointless.
>
> Back to the case in question: do we think there is a credible case where
> the "dying" cpu can show up in our "for_each_cpu_online()" loop? The
> original author of the code was worried enough to make a test, but thought
> that the appropriate action was to silently skip it. You want to add a WARN_ON,
> which will cause users who read the console logs to worry, but that most users
> will never see.
>
> -Tony


