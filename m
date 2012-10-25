Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab2JYA5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:57:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61123 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab2JYA5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:57:05 -0400
MIME-Version: 1.0
In-Reply-To: <5088725B.2090700@linux.vnet.ibm.com>
References: <20121012125708.GJ10110@dhcp22.suse.cz> <20121023164546.747e90f6.akpm@linux-foundation.org>
 <20121024062938.GA6119@dhcp22.suse.cz> <20121024125439.c17a510e.akpm@linux-foundation.org>
 <50884F63.8030606@linux.vnet.ibm.com> <20121024134836.a28d223a.akpm@linux-foundation.org>
 <20121024210600.GA17037@liondog.tnic> <50885B2E.5050500@linux.vnet.ibm.com>
 <20121024224817.GB8828@liondog.tnic> <5088725B.2090700@linux.vnet.ibm.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Wed, 24 Oct 2012 20:56:45 -0400
X-Google-Sender-Auth: OdHhZPZ7FCsGxZfPqComh-eQQHQ
Message-ID: <CAHGf_=pfdgoeG5pPJb+UgjqfieU1yxt=46FGW1=th0RbgVKNRQ@mail.gmail.com>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 6:57 PM, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On 10/24/2012 03:48 PM, Borislav Petkov wrote:
>> On Wed, Oct 24, 2012 at 02:18:38PM -0700, Dave Hansen wrote:
>>> Sounds fairly valid to me. But, it's also one that would not be harmed
>>> or disrupted in any way because of a single additional printk() during
>>> each suspend-to-disk operation.
>>
>> back to the drop_caches patch. How about we hide the drop_caches
>> interface behind some mm debugging option in "Kernel Hacking"? Assuming
>> we don't need it otherwise on production kernels. Probably make it
>> depend on CONFIG_DEBUG_VM like CONFIG_DEBUG_VM_RB or so.
>>
>> And then also add it to /proc/vmstat, in addition.
>
> That effectively means removing it from the kernel since distros ship
> with those config options off.  We don't want to do that since there
> _are_ valid, occasional uses like benchmarking that we want to be
> consistent.

Agreed. we don't want to remove valid interface never.
