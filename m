Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2DTNMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:12:50 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:2185 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab2DTNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:12:49 -0400
X-IronPort-AV: E=Sophos;i="4.75,454,1330905600"; 
   d="scan'208";a="12048713"
Message-ID: <1334927566.28331.80.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Andrew Cooper <Andrew.Cooper3@citrix.com>
CC: Lin Ming <mlin@ss.pku.edu.cn>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 20 Apr 2012 14:12:46 +0100
In-Reply-To: <4F915C43.4020207@citrix.com>
References: <1334913957.2863.1.camel@hp6530s>  <4F913340.4000202@citrix.com>
	 <1334920396.2863.16.camel@hp6530s>
	 <1334925508.28331.63.camel@zakaz.uk.xensource.com>
	 <4F915C43.4020207@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 13:53 +0100, Andrew Cooper wrote:
> >
> > Under what circumstances can these hypercalls fail? Would a BUG_ON be
> > appropriate/
> 
> -EFAULT, -EPERM, anything xsm_apic() could return (which looks only to
> be -EPERM).

So either the guest has called a hypercall which it is not permitted to
or it has called it with invalid parameters of one sort or another. Both
of these would be a code bug in the guest and therefore asserting that
no failure occurred is reasonable?

What could the caller do with the error other than log it and collapse?

> The call into Xen itself will return 0 as a value if an
> invalid physbase is passed in the hypercall.

> So a BUG_ON() is not safe/sensible for domU.

I think you have successfully argued that it is ;-)

Ian.

