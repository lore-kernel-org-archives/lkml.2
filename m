Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2LJRF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 12:05:27 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:54526 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab2LJRF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 12:05:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,252,1355097600"; 
   d="scan'208";a="40055"
Message-ID: <50C61653.70107@citrix.com>
Date: Mon, 10 Dec 2012 18:05:23 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen-blkfront: implement safe version
 of llist_for_each_entry
References: <1354630913-17287-1-git-send-email-roger.pau@citrix.com> <1354630913-17287-2-git-send-email-roger.pau@citrix.com> <20121207202003.GA9462@phenom.dumpdata.com> <50C5D276.6090009@citrix.com> <20121210151533.GE6955@localhost.localdomain>
In-Reply-To: <20121210151533.GE6955@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/12 16:15, Konrad Rzeszutek Wilk wrote:
> On Mon, Dec 10, 2012 at 01:15:50PM +0100, Roger Pau Monné wrote:
>> On 07/12/12 21:20, Konrad Rzeszutek Wilk wrote:
>>> On Tue, Dec 04, 2012 at 03:21:53PM +0100, Roger Pau Monne wrote:
>>>> Implement a safe version of llist_for_each_entry, and use it in
>>>> blkif_free. Previously grants where freed while iterating the list,
>>>> which lead to dereferences when trying to fetch the next item.
>>>
>>> Looks like xen-blkfront is the only user of this llist_for_each_entry.
>>>
>>> Would it be more prudent to put the macro in the llist.h file?
>>
>> I'm not able to find out who is the maintainer of llist, should I just
>> CC it's author?
> 
> Sure. I CC-ed akpm here to solicit his input as well. Either way I am
> OK wit this being in xen-blkfront but it just seems that it could
> be useful in the llist file since that is where the non-safe version
> resides.

I'm going to resend this series with llist_for_each_entry_safe added to
llist.h in a separated patch. I wouldn't like to delay this series
because we cannot get llist_for_each_entry_safe added to llist.h, that's
why I've added it to blkfront in the first place.

