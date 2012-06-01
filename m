Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773Ab2FAH5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 03:57:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:6128 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621Ab2FAH5x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 03:57:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150301491"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
        "'xen-devel@lists.xensource.com'" <xen-devel@lists.xensource.com>,
        Borislav Petkov <bp@amd64.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: [Xen-devel] [PATCH 1/2] xen/mce: Add mcelog support for Xen
 platform
Thread-Topic: [Xen-devel] [PATCH 1/2] xen/mce: Add mcelog support for Xen
 platform
Thread-Index: AQHNP17XM9HNPWGJrkGbs3SSikmUqJblFFsw
Date: Fri, 1 Jun 2012 07:57:51 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC82923352010D2@SHSMSX101.ccr.corp.intel.com>
References: <DE8DF0795D48FD4CA783C40EC82923351FEE7C@SHSMSX101.ccr.corp.intel.com>
 <20120531161139.GA13939@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923351FFB11@SHSMSX101.ccr.corp.intel.com>
 <20120531173137.GA31735@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC82923352000E2@SHSMSX101.ccr.corp.intel.com>
 <20120531185444.GA7557@phenom.dumpdata.com>
In-Reply-To: <20120531185444.GA7557@phenom.dumpdata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
>>>> That's vMCE injection logic.
>>> 
>>> Are you sure about it? The comments in it speak of piggybacking on
>>> the native MCE handling routines. But since that is not used anymore
>>> do you need to use a different mechanism?
>> 
>> What is not used anymore? what's your concern about
>> cvt_gate_to_trap? I really confused here. Could you elaborate more?
> 
> Well, the mce.c is not involved anymore. So if it we are piggybacking
> on the native MCE handling routines - those routines
> (do_machine_check) won't deliever the data to your driver anymore?
> B/c the do_machine_check is doing mce_log which spools data. But your
> driver is using a different system to de-spool the data - and it does
> not use the mcelog structure array.

native mce is still there, we didn't mask it.
what is not used is native mce_log, w/ guest info (like guest address) when running at xen platform,
instead we use xen_mce_log, a self-contained logic getting real physical error info from xen hypervisor.
that's just what we expected.

> 
> .. snip.
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>>> c/s a01ee165a132fadb57659d26246e340d6ac53265
>>> 
>>> Which I think the tree is based on too.
>> 
>> So it would not be stuck?
> 
> I've no idea what you mean here. Could you elaborate please?

What I meant here is, it should not meet confliction when you patched our patches to latest linus tree.
(Per my understanding, you meet confliction when patched, right? any misunderstanding please tell me)

Thanks,
Jinsong