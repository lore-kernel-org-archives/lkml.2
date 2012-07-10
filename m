Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab2GJRgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:36:53 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49367 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab2GJRgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:36:51 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: David Miller <davem@davemloft.net>
cc: ebiederm@xmission.com, dilip.daya@hp.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        serge@hallyn.com
Subject: Re: [PATCH 2/2] bonding: debugfs and network namespaces are incompatible
In-reply-to: <20120709.144932.243254122059983829.davem@davemloft.net>
References: <20120706194741.GA22113@mail.hallyn.com> <87y5ms3bfi.fsf_-_@xmission.com> <87sjd03bdw.fsf_-_@xmission.com> <20120709.144932.243254122059983829.davem@davemloft.net>
Comments: In-reply-to David Miller <davem@davemloft.net>
   message dated "Mon, 09 Jul 2012 14:49:32 -0700."
X-Mailer: MH-E 8.2; nmh 1.4; GNU Emacs 23.4.1
Date: Tue, 10 Jul 2012 10:36:12 -0700
Message-ID: <15459.1341941772@death.nxdomain>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071017-7182-0000-0000-000001F33B38
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

>From: ebiederm@xmission.com (Eric W. Biederman)
>Date: Mon, 09 Jul 2012 13:52:43 -0700
>
>> 
>> The bonding debugfs support has been broken in the presence of network
>> namespaces since it has been added.  The debugfs support does not handle
>> multiple bonding devices with the same name in different network
>> namespaces.
>> 
>> I haven't had any bug reports, and I'm not interested in getting any.
>> Disable the debugfs support when network namespaces are enabled.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
>Applied.

	Since distro kernels appear to set CONFIG_NET_NS, doesn't this
effectively disable debugfs for bonding on most distros?

	Do the other network device drivers that support debugfs have a
similar problem?  E.g., if each of two namespaces have an skge device
with the same name, will there be a debugfs conflict there as well?

	-J

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

