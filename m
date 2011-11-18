Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1KRDJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 22:09:04 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:33158 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1KRDJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 22:09:03 -0500
Message-ID: <4EC5CC3B.4050808@oracle.com>
Date: Fri, 18 Nov 2011 11:08:43 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Thunderbird/3.1.15
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 1/3] xen/granttable: Introducing grant
 table V2 stucture
References: <4EC3B62F.6080702@oracle.com>	<1321451304-13559-1-git-send-email-annie.li@oracle.com>	<1321526148.3664.263.camel@zakaz.uk.xensource.com>	<4EC53119.7060307@oracle.com> <20111117162955.GA6758@phenom.dumpdata.com>
In-Reply-To: <20111117162955.GA6758@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4EC5CC4A.002B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-11-18 0:29, Konrad Rzeszutek Wilk wrote:
>>> The more normal way to do this would be to make gnttab_interface a
>>> pointer, define gnttab_v1_ops and do:
>>> 	gnttab_interface =&gnttab_v1_ops;
>>> or if the pointer overhead is significant remove that and just do a
>>> struct assignment:
>>> 	gnttab_interface = gnttab_v1_ops;
>>>
>> If using this way, we need two more public structures(gnttab_v1_ops
>> and gnttab_v2_ops), and two more functions to initialize those two
>> structures and then initialize the pointer gnttab_interface. It is
>> more complicated, am i missing something?
> Why two functions? I agree on the structures - but they need not to be
> public (they can be static).
>
> For a good example look at how apic_physflat is done.
Thanks, static structure is simpler and clean. I am very glad to change 
that.:-)

Thanks
Annie
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel
