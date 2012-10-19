Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757891Ab2JSHrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:47:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:26158 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756922Ab2JSHrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:47:47 -0400
X-IronPort-AV: E=Sophos;i="4.80,612,1344182400"; 
   d="scan'208";a="6029856"
Message-ID: <50810101.1070201@cn.fujitsu.com>
Date: Fri, 19 Oct 2012 15:28:01 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH v3 3/9] memory-hotplug: flush the work for the node when
 the node is offlined
References: <1350629202-9664-1-git-send-email-wency@cn.fujitsu.com> <1350629202-9664-4-git-send-email-wency@cn.fujitsu.com> <CAHGf_=oAH+Ky9JbrMrEsd53=a1NBq1+jtr1HkBwnGm4qBZCRAw@mail.gmail.com>
In-Reply-To: <CAHGf_=oAH+Ky9JbrMrEsd53=a1NBq1+jtr1HkBwnGm4qBZCRAw@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 15:22:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 15:22:10,
	Serialize complete at 2012/10/19 15:22:10
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/19/2012 03:01 PM, KOSAKI Motohiro Wrote:
> On Fri, Oct 19, 2012 at 2:46 AM,  <wency@cn.fujitsu.com> wrote:
>> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>
>> If the node is onlined after it is offlined, we will clear the memory
>> to store the node's information. This structure contains struct work,
>> so we should flush work before the work's information is cleared.
> 
> This explanation is incorrect. Even if you don't call memset(), you should
> call flush_work() at offline event. Because of, after offlinining, we
> shouldn't touch any node data. Alive workqueue violate this principle.

Yes, I will update the description.

> 
> And, hmmm... Wait. Usually workqueue shutdowning has two phase. 1)
> inhibit enqueue new work 2) flush work. Otherwise other cpus may
> enqueue new work after flush_work(). Where is (1)?
> 


We schedule the work only when a memory section is onlined/offlined on this
node. When we come here, all the memory on this node has been offlined,
so we won't enqueue new work to this work. I will add a comment
to descript this.

Thanks
Wen Congyang


