Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab2DTO7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:59:16 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55517 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2DTO7O convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 20 Apr 2012 10:59:14 -0400
Message-Id: <4F9195DE020000780007EEB1@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 20 Apr 2012 15:59:10 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Lin Ming" <mlin@ss.pku.edu.cn>
Cc: "Andrew Cooper" <Andrew.Cooper3@citrix.com>,
        "Ian Campbell" <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
References: <1334913957.2863.1.camel@hp6530s> <4F913340.4000202@citrix.com>
 <1334920396.2863.16.camel@hp6530s>
 <1334925508.28331.63.camel@zakaz.uk.xensource.com>
 <4F915C43.4020207@citrix.com>
 <1334927566.28331.80.camel@zakaz.uk.xensource.com>
 <CAF1ivSaPshQf=BZ1gKLUq1yRF_MWeyjjVWkfv+E_jT+K5CFmAA@mail.gmail.com>
In-Reply-To: <CAF1ivSaPshQf=BZ1gKLUq1yRF_MWeyjjVWkfv+E_jT+K5CFmAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.04.12 at 16:50, Lin Ming <mlin@ss.pku.edu.cn> wrote:
> On Fri, Apr 20, 2012 at 9:12 PM, Ian Campbell <Ian.Campbell@citrix.com> wrote:
>> On Fri, 2012-04-20 at 13:53 +0100, Andrew Cooper wrote:
>>> >
>>> > Under what circumstances can these hypercalls fail? Would a BUG_ON be
>>> > appropriate/
>>>
>>> -EFAULT, -EPERM, anything xsm_apic() could return (which looks only to
>>> be -EPERM).
>>
>> So either the guest has called a hypercall which it is not permitted to
>> or it has called it with invalid parameters of one sort or another. Both
>> of these would be a code bug in the guest and therefore asserting that
>> no failure occurred is reasonable?
>>
>> What could the caller do with the error other than log it and collapse?
>>
>>> The call into Xen itself will return 0 as a value if an
>>> invalid physbase is passed in the hypercall.
>>
>>> So a BUG_ON() is not safe/sensible for domU.
>>
>> I think you have successfully argued that it is ;-)
> 
> BUG_ON is too severe. How about WARN_ON?
> 
> ret = hypercall(...)
> 
> if (ret) {
>    WARN_ON(1);
>    return -1;
> }

But if you go with this, please use the more modern

if (WARN_ON(ret))
	return -1;

Jan

