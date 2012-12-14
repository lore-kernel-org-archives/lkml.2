Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2LNNUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:20:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:37158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2LNNUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:20:54 -0500
X-IronPort-AV: E=Sophos;i="4.84,281,1355068800"; 
   d="scan'208";a="6400252"
Message-ID: <50CB29D2.8040602@cn.fujitsu.com>
Date: Fri, 14 Dec 2012 21:29:54 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        wim@iguana.be, Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: kernel panic when reboot
References: <50CAF165.5080209@cn.fujitsu.com> <20121214110253.GB4966@liondog.tnic>
In-Reply-To: <20121214110253.GB4966@liondog.tnic>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/14 21:19:59,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/14 21:19:59,
	Serialize complete at 2012/12/14 21:19:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 07:02 PM, Borislav Petkov wrote:
> On Fri, Dec 14, 2012 at 05:29:09PM +0800, Wanlong Gao wrote:
>> Hi, 
>>
>> I hit the kernel panic when reboot the system today, just system reboot can cause kernel panic.
>>
>> $ git describe 
>> v3.7-7784-g7313264
>>
>> The config file is attached.
>> And the crash screen is uploaded here http://www.tiikoni.com/tis/view/?id=e187047
> 
> AFAICT, it looks like list corruption in the mutex_lock path when
> trying to grab the watchdog->lock, when we're coming down from
> mei_watchdog_unregister().
> 
> Is it reproducible?

It's panicked every time I reboot the system.

Thanks,
Wanlong Gao

> 
> Btw, this is pre -rc1 kernel so I wouldn't take any issues it has too
> seriously before Linus hasn't done -rc1 at least. Testing arbitrary
> points in the history is known to lead to all kinds of issues which
> aren't reproducible later in my experience.
> 
> Adding a MEI guy to CC just in case.
> 
> HTH.
> 

