Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab1EYQoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:44:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:8790 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932931Ab1EYQoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:44:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,268,1304319600"; 
   d="scan'208";a="4700092"
From: "Luck, Tony" <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "Huang, Ying" <ying.huang@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 25 May 2011 09:44:10 -0700
Subject: RE: [RFC 0/9] mce recovery for Sandy Bridge server
Thread-Topic: [RFC 0/9] mce recovery for Sandy Bridge server
Thread-Index: AcwaoYLsfcvpyJlgTISJI9Kg5J/MOgAWDfEA
Message-ID: <987664A83D2D224EAE907B061CE93D5301D5DAB84D@orsmsx505.amr.corp.intel.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <4DDC9B97.6000605@jp.fujitsu.com>
In-Reply-To: <4DDC9B97.6000605@jp.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> How about separating stuffs in:
> step1) Add support for AR in user space :
>   - send sigbus to affected processes, poison affected memory
>   - panic if error is in kernel
> step2) Add support for AR in kernel
>   - some new notify/handle mechanism etc.
>
> It seems too big jump for me.

Agreed - we can go step by step with different recovery cases. Deciding
which to implement is a classic benefit vs. effort trade off.

For each case determine some ball-park numbers for the percentage of
memory that will be in the state you wish to recover (hence user-mode
scores very highly because most people buy machines to run applications,
though there are some exceptions like file servers).

Determine the effort and invasiveness of a solution to recover - here
it is clear that a way to handle arbitrary kernel memory corruption
is never going to fly - but there is hope for some simple cases like
copy to/from user (that already are specially tagged so that user level
page faults can be processed).

-Tony
