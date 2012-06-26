Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2FZLF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 07:05:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:46577 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab2FZLF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 07:05:26 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19323340@ORSMSX104.amr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC829233524C532@SHSMSX101.ccr.corp.intel.com>
	<4FE362C0020000780008B2CD@nat28.tlf.novell.com>
	<DE8DF0795D48FD4CA783C40EC82923352542BD@SHSMSX101.ccr.corp.intel.com>
	<4FE475BE020000780008B624@nat28.tlf.novell.com>
	<DE8DF0795D48FD4CA783C40EC8292335254989@SHSMSX101.ccr.corp.intel.com>
	<4FE4A636020000780008B756@nat28.tlf.novell.com>
	<3908561D78D1C84285E8C5FCA982C28F19323340@ORSMSX104.amr.corp.intel.com>
Date: Tue, 26 Jun 2012 12:05:25 +0100
X-Google-Sender-Auth: 3prl5DUgWXzn1tm7cc0URBMNNSk
Message-ID: <CAFLBxZaqvqNZK0CutdVO2KMZ7CfnwS5Mp99WTwyKp_hkToKrYg@mail.gmail.com>
Subject: Re: [Xen-devel] [vMCE design RFC] Xen vMCE design
From: George Dunlap <George.Dunlap@eu.citrix.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jan Beulich <JBeulich@suse.com>, "Liu, Jinsong" <jinsong.liu@intel.com>,
        "Jiang, Yunhong" <yunhong.jiang@intel.com>, Keir Fraser <keir@xen.org>,
        "Raj, Ashok" <ashok.raj@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Shan, Haitao" <haitao.shan@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dugger, Donald D" <donald.d.dugger@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Zhang, Xiantao" <xiantao.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 4:21 PM, Luck, Tony <tony.luck@intel.com> wrote:
>>>> I think that we minimally need to retain the MCG_CAP register
>>>> as being of potentially variable content (and hence needing
>>>> saving/restoring on migration). To support this in a forward
>>>> compatible manner, we may have to have a way to tell the
>>>> hypervisor e.g. via command line option which extra MSRs
>>>> have to be treated read-as-zero/writes-ignored upon guest
>>>> accesses.
>>>
>>> Seems unnecessary, reason as above.
>>
>> So going forward you see no possibility of additions to the
>> interface that might warrant allowing more bits to be set in
>> MCG_CAP than you define to be set here? That really looks
>> unrealistic to me.
>
> More bits can be added to MCG_CAP - but this becomes a hard
> problem for migration because most OS guests only look at
> MCG_CAP at boot time (linux certainly does) ... so if you migrate
> and change MCG_CAP to match the new host, the guest will have
> no idea that things changed.

Typically if you have a heterogeneous pool (i.e., different processors
with different CPUID bits) you typically have to calculate the minimum
subset of features available on all processors and only expose those
to the guest.  It wouldn't be too hard to extend that to vMCEs if we
had to.  Alternately, as Jan says, we could just fake things out when
we need to.

 -George
