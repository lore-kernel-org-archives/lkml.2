Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab2JRQbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:31:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:64238 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2JRQbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:31:43 -0400
X-IronPort-AV: E=Sophos;i="4.80,608,1344211200"; 
   d="scan'208";a="211748677"
Message-ID: <50802EEC.6060102@citrix.com>
Date: Thu, 18 Oct 2012 17:31:40 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, <linux-acpi@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <lenb@kernel.org>
Subject: Re: [Xen-devel] Is: axe read_tscp pvops call. Was: Re: [RFC] ACPI
 S3 and Xen (suprisingly small\!).
References: <1350481786-4969-1-git-send-email-konrad.wilk@oracle.com>	<507ED6C0.4020503@zytor.com>	<20121017161036.GA10691@phenom.dumpdata.com>	<507EE1C3.7070300@zytor.com> <20121017165452.GA22740@phenom.dumpdata.com>
In-Reply-To: <20121017165452.GA22740@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/12 17:54, Konrad Rzeszutek Wilk wrote:
> On Wed, Oct 17, 2012 at 09:50:11AM -0700, H. Peter Anvin wrote:
>> On 10/17/2012 09:10 AM, Konrad Rzeszutek Wilk wrote:
>>> On Wed, Oct 17, 2012 at 09:03:12AM -0700, H. Peter Anvin wrote:
>>>> On 10/17/2012 06:49 AM, Konrad Rzeszutek Wilk wrote:
>>>>>
>>>>> Note: These are the other patches that went in 3.7-rc1:
>>>>> xen/bootup: allow {read|write}_cr8 pvops call [https://lkml.org/lkml/2012/10/10/339]
>>>>> xen/bootup: allow read_tscp call for Xen PV guests. [https://lkml.org/lkml/2012/10/10/340]
>>>>>
>>>>
>>>> So WTF do we have a read_tscp PV call?  Again, if there isn't a user
>>>> we should just axe it...
>>>
>>> Let me spin off a patch to see if that can be done.
>>>
>>
>> Could you do an audit for other pvops calls that have no users?  If
>> the *only* user is lguest, we should talk about it, too...
> 
> I can do that - but I don't want to be hasty here. There is a bit of
> danger here - for example the read_pmc (or read_tsc) is not in use right
> now. But it might be when one starts looking at making perf be able to
> analyze the hypervisor (hand-waving the implementation details). So while
> removing read_pmc now sounds good, it might be needed in the future.

I don't see any reason why would ever need a PV-specific implementation
of either read_pmc or read_tsc.  And I certainly agree with hpa that
leaving them around 'just in case' isn't useful.

As for 'perf', since Xen already provides a virtual PMU for HVM guests
It's not clear why we would spend the effort to implement another
mechanism for PV guests (instead of using the virtual PMU from a PVH guest).

David
