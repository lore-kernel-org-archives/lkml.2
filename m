Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab2FLHTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:19:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20402 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2FLHTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:19:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,394,1336320000"; 
   d="scan'208";a="5167240"
Message-ID: <4FD6EE5F.60206@cn.fujitsu.com>
Date: Tue, 12 Jun 2012 15:23:11 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 1/3] start vm after reseting it
References: <4FB9E4CE.8060709@cn.fujitsu.com>	<4FB9E57C.5040003@cn.fujitsu.com> <20120530161720.7c9b88b9@doriath.home>
In-Reply-To: <20120530161720.7c9b88b9@doriath.home>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 15:19:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/06/12 15:19:43,
	Serialize complete at 2012/06/12 15:19:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 05/31/2012 03:17 AM, Luiz Capitulino Wrote:
> On Mon, 21 May 2012 14:49:32 +0800
> Wen Congyang <wency@cn.fujitsu.com> wrote:
> 
>> The guest should run after reseting it, but it does not
>> run if its old state is RUN_STATE_INTERNAL_ERROR or RUN_STATE_PAUSED.
>>
>> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>>  vl.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/vl.c b/vl.c
>> index 23ab3a3..7f5fed8 100644
>> --- a/vl.c
>> +++ b/vl.c
>> @@ -1539,6 +1539,7 @@ static bool main_loop_should_exit(void)
>>          if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
>>              runstate_check(RUN_STATE_SHUTDOWN)) {
>>              runstate_set(RUN_STATE_PAUSED);
>> +            vm_start();
> 
> Please, drop the runstate_set() call. I think you also have to
> to call bdrv_iostatus_reset(), as qmp_cont() does.

I am not sure whether we should call it here. I think you may be right,
so I will do it as you suggested.

Thanks
Wen Congyang

> 
>>          }
>>      }
>>      if (qemu_powerdown_requested()) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

