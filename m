Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1FJNz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:55:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132Ab1FJNz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:55:58 -0400
Message-ID: <4DF22245.20008@redhat.com>
Date: Fri, 10 Jun 2011 15:55:17 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tim Deegan <Tim.Deegan@citrix.com>
CC: Stefano@phlegethon.org, Paul Menage <menage@google.com>,
        xen-devel@lists.xensource.com, Keir Fraser <keir@xen.org>,
        Stabellini <stefano.stabellini@eu.citrix.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Keir Fraser <keir.xen@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        KAMEZAWA@phlegethon.org, Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Subject: Re: [Xen-devel] Possible shadow bug
References: <BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>	<4DE8D50F.1090406@redhat.com>	<BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com>	<4DEE26E7.2060201@redhat.com>	<20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com>	<4DF0801F.9050908@redhat.com>	<alpine.DEB.2.00.1106091311530.12963@kaball-desktop>	<20110609150133.GF5098@whitby.uk.xensource.com>	<4DF0F90D.4010900@redhat.com>	<20110610100139.GG5098@whitby.uk.xensource.com> <20110610101011.GH5098@whitby.uk.xensource.com>
In-Reply-To: <20110610101011.GH5098@whitby.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2011 12:10 PM, Tim Deegan wrote:
> At 11:01 +0100 on 10 Jun (1307703699), Tim Deegan wrote:
>> Actually, looking at the disassembly you posted, it looks more like it
>> might be an emulator bug in Xen; if Xen finds itself emulating the IMUL
>> instruction and either gets the logic wrong or does the memory access
>> wrong, it could cause that failure.  And one reason that Xen emulates
>> instructions is if the memory operand is on a pagetable that's shadowed
>> (which might be a page that was recently a pagetable).
>>
>> ISTR that even though the RHEL xen reports a 3.0.x version it has quite
>> a lot of backports in it.  Does it have this patch?
>> http://hg.uk.xensource.com/xen-3.1-testing.hg/rev/e8fca4c42d05
> Oops, that URL doesn't work; I meant this:
> http://xenbits.xen.org/xen-3.1-testing.hg/rev/e8fca4c42d05
>
> Tim.
>
Tim, Thank you very much!
We were missing that cs and it solved problem.

-- 
Thanks,
  Igor

