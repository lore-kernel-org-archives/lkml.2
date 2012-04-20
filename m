Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab2DTNUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:20:22 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:46322 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2DTNUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:20:21 -0400
X-IronPort-AV: E=Sophos;i="4.75,454,1330923600"; 
   d="scan'208";a="191316724"
Message-ID: <4F916291.2020105@citrix.com>
Date: Fri, 20 Apr 2012 14:20:17 +0100
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Lin Ming <mlin@ss.pku.edu.cn>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with hypercall
References: <1334913957.2863.1.camel@hp6530s>  <4F913340.4000202@citrix.com>  <1334920396.2863.16.camel@hp6530s>  <1334925508.28331.63.camel@zakaz.uk.xensource.com>  <4F915C43.4020207@citrix.com> <1334927566.28331.80.camel@zakaz.uk.xensource.com>
In-Reply-To: <1334927566.28331.80.camel@zakaz.uk.xensource.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/04/12 14:12, Ian Campbell wrote:
> On Fri, 2012-04-20 at 13:53 +0100, Andrew Cooper wrote:
>>> Under what circumstances can these hypercalls fail? Would a BUG_ON be
>>> appropriate/
>> -EFAULT, -EPERM, anything xsm_apic() could return (which looks only to
>> be -EPERM).
> So either the guest has called a hypercall which it is not permitted to
> or it has called it with invalid parameters of one sort or another. Both
> of these would be a code bug in the guest and therefore asserting that
> no failure occurred is reasonable?
>
> What could the caller do with the error other than log it and collapse?
>
>> The call into Xen itself will return 0 as a value if an
>> invalid physbase is passed in the hypercall.
>> So a BUG_ON() is not safe/sensible for domU.
> I think you have successfully argued that it is ;-)
>
> Ian.
>

So I have.  -EMoreCoffee

Yes - I meant to say that BUG_ON() was ok for domU.

-- 
Andrew Cooper - Dom0 Kernel Engineer, Citrix XenServer
T: +44 (0)1223 225 900, http://www.citrix.com

