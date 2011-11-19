Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab1KSDhZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 22:37:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:61218 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab1KSDhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 22:37:24 -0500
Message-ID: <4EC72454.8000502@oracle.com>
Date: Sat, 19 Nov 2011 11:36:52 +0800
From: annie li <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Durrant <Paul.Durrant@citrix.com>
Subject: Re: [Xen-devel] Re: [PATCH 2/3] xen/granttable: Grant tables V2 implementation
References: <4EC3B62F.6080702@oracle.com> <1321451372-13596-1-git-send-email-annie.li@oracle.com> <4EC62FE5.2080608@oracle.com> <1321614166.3664.311.camel@zakaz.uk.xensource.com> <20111118135221.GC12433@phenom.dumpdata.com> <1321624845.3664.354.camel@zakaz.uk.xensource.com> <4EC6837F.1050201@oracle.com> <20111118180500.GA19469@phenom.dumpdata.com>
In-Reply-To: <20111118180500.GA19469@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4EC7246F.00D9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2011-11-19 2:05, Konrad Rzeszutek Wilk wrote:
>> So we have two candidates:
>> xen_raw_printk + panic
>> panic + earlyprintk=xen
>>
>> If panic does work with earlyprintk, then the latter one is better.
>> Otherwise, there will be duplicated string printed out with
>> 'earlyprintk=xen'.
>>     
>
> The idea is just to have one function. Whichever prints the
> string and panics the machine. If 'panic' does this properly
> (and properly meaning it actually prints data when using
> the earlyprintk=xen as well as console=hvc0) printout system
> the we cuold just use 'panic' and not worry about it.
>
>   
Ok.
> But if it does not, then we (and by we I mean you) should 
> provide a variant of panic() that prints the data properly using the 
> earlprintk mechanism. Preferrabily to make it generic.
>   
So this work depends on whether panic works well with earlyprink=xen, I 
will do some test on panic first.

Thanks
Annie
