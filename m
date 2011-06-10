Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab1FJPjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 11:39:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab1FJPjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 11:39:43 -0400
Message-ID: <4DF23A92.8050909@redhat.com>
Date: Fri, 10 Jun 2011 17:38:58 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tim Deegan <Tim.Deegan@citrix.com>
CC: Pasi K?rkk?inen <pasik@iki.fi>, xen-devel@lists.xensource.com,
        Keir Fraser <keir@xen.org>,
        Stabellini <stefano.stabellini@eu.citrix.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Keir Fraser <keir.xen@gmail.com>, Paul Menage <menage@google.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Possible shadow bug
References: <BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com> <4DEE26E7.2060201@redhat.com> <20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com> <4DF0801F.9050908@redhat.com> <alpine.DEB.2.00.1106091311530.12963@kaball-desktop> <20110609150133.GF5098@whitby.uk.xensource.com> <4DF0F90D.4010900@redhat.com> <20110610100139.GG5098@whitby.uk.xensource.com> <20110610101011.GH5098@whitby.uk.xensource.com> <20110610114821.GB32595@reaktio.net> <20110610124034.GI5098@whitby.uk.xensource.com>
In-Reply-To: <20110610124034.GI5098@whitby.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 02:40 PM, Tim Deegan wrote:
> At 14:48 +0300 on 10 Jun (1307717301), Pasi K?rkk?inen wrote:
>> On Fri, Jun 10, 2011 at 11:10:11AM +0100, Tim Deegan wrote:
>>> At 11:01 +0100 on 10 Jun (1307703699), Tim Deegan wrote:
>>>> ISTR that even though the RHEL xen reports a 3.0.x version it has quite
>>>> a lot of backports in it.  Does it have this patch?
>>>> http://hg.uk.xensource.com/xen-3.1-testing.hg/rev/e8fca4c42d05
>>> Oops, that URL doesn't work; I meant this:
>>> http://xenbits.xen.org/xen-3.1-testing.hg/rev/e8fca4c42d05
>>>
>> RHEL5 Xen (hypervisor) reports version as 3.1.2-xyz..
> Based on a quick scrobble through the CentOS 5.6 SRPMs it looks like a
> 3.1.0 hypervisor with a bunch of extra patches, but not this one.  This
> is very likely the cause of the crash in mem_cgroup_create(), and
> probably the corruptions too.  That would explain why they didn't happen
> on a 4.0.x SLES11 Xen, but not really why the original patch in this
> thread made it go away.
>
Maybe it changes timing so that imul is executed with correct memory 
content?
Putting extra printk inside zone loop or flushing tlb before it also 
make problem
go away. Or may be problem just becomes invisible and memory is corrupted at
another place.

PS:
Well, never mind. I do not know what I'm talking about.
> Cheers,
>
> Tim.
>


-- 
Thanks,
  Igor

