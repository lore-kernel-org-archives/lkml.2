Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab1FIQsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 12:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab1FIQsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 12:48:41 -0400
Message-ID: <4DF0F90D.4010900@redhat.com>
Date: Thu, 09 Jun 2011 18:47:09 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tim Deegan <Tim.Deegan@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xensource.com, Keir Fraser <keir@xen.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Keir Fraser <keir.xen@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Paul Menage <menage@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] Possible shadow bug
References: <4DE64F0C.3050203@redhat.com> <20110601152039.GG4266@tiehlicka.suse.cz> <4DE66BEB.7040502@redhat.com> <BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com> <4DE8D50F.1090406@redhat.com> <BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com> <4DEE26E7.2060201@redhat.com> <20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com> <4DF0801F.9050908@redhat.com> <alpine.DEB.2.00.1106091311530.12963@kaball-desktop> <20110609150133.GF5098@whitby.uk.xensource.com>
In-Reply-To: <20110609150133.GF5098@whitby.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 05:01 PM, Tim Deegan wrote:
> At 13:40 +0100 on 09 Jun (1307626812), Stefano Stabellini wrote:
>> CC'ing xen-devel and Tim.
>>
>> This is a comment from a previous email in the thread:
>>
>>> It most easily reproduced only on xen hvm 32bit guest under heavy vcpus
>>> contention for real cpus resources (i.e. I had to overcommit cpus and
>>> run several cpu hog tasks on host to make guest crash on reboot cycle).
>>> And from last experiments, crash happens only on on hosts that doesn't
>>> have hap feature or if hap is disabled in hypervisor.
>> it makes me think that it is a shadow pagetables bug; see details below.
>> You can find more details on it following this thread on the lkml.
> Oh dear.  I'm having a look at the linux code now to try and understand
> the behaviour.  In the meantime, what version of Xen was this on?  If
It's rhel5.6 xen. I've tried to test on SLES 11 that has 4.0.1 xen, however
wasn't able to reproduce problem. (I'm not sure if hap was turned off in 
this
case). More detailed info can be found at RHBZ#700565

> you're willing to try recompiling Xen with some small patches that
> disable the "cleverer" parts of the shadow pagetable code that might
> indicate something.  (Of course, it might just change the timing to
> obscure a real linux bug too.)
>
Haven't got to this part yet. But looks like it's the only option left.

> The only time I've seen a corruption like this, with a mapping
> transiently going to the wrong frame, it turned out to be caused by
> 32-bit pagetable-handling code writing a PAE PTE with a single 64-bit
> write (which is not atomic on x86-32), and the TLB happening to see the
> intermediate, half-written entry.  I doubt that there's any bug like
> that in linux, though, or we'd surely have seen it before now.
>
> Cheers,
>
> Tim.
>


-- 
Thanks,
  Igor

