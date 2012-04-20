Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2DTPAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:00:00 -0400
Received: from [124.207.24.138] ([124.207.24.138]:45323 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756732Ab2DTO77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <1334927566.28331.80.camel@zakaz.uk.xensource.com>
References: <1334913957.2863.1.camel@hp6530s>
	<4F913340.4000202@citrix.com>
	<1334920396.2863.16.camel@hp6530s>
	<1334925508.28331.63.camel@zakaz.uk.xensource.com>
	<4F915C43.4020207@citrix.com>
	<1334927566.28331.80.camel@zakaz.uk.xensource.com>
Date: Fri, 20 Apr 2012 22:50:57 +0800
Message-ID: <CAF1ivSaPshQf=BZ1gKLUq1yRF_MWeyjjVWkfv+E_jT+K5CFmAA@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with hypercall
From: Lin Ming <mlin@ss.pku.edu.cn>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 9:12 PM, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> On Fri, 2012-04-20 at 13:53 +0100, Andrew Cooper wrote:
>> >
>> > Under what circumstances can these hypercalls fail? Would a BUG_ON be
>> > appropriate/
>>
>> -EFAULT, -EPERM, anything xsm_apic() could return (which looks only to
>> be -EPERM).
>
> So either the guest has called a hypercall which it is not permitted to
> or it has called it with invalid parameters of one sort or another. Both
> of these would be a code bug in the guest and therefore asserting that
> no failure occurred is reasonable?
>
> What could the caller do with the error other than log it and collapse?
>
>> The call into Xen itself will return 0 as a value if an
>> invalid physbase is passed in the hypercall.
>
>> So a BUG_ON() is not safe/sensible for domU.
>
> I think you have successfully argued that it is ;-)

BUG_ON is too severe. How about WARN_ON?

ret = hypercall(...)

if (ret) {
   WARN_ON(1);
   return -1;
}


>
> Ian.
