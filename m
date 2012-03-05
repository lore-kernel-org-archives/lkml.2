Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2CEXWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 18:22:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:8649 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757814Ab2CEXV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 18:21:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="73922968"
From: "Luck, Tony" <tony.luck@intel.com>
To: Jonathan Nieder <jrnieder@gmail.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
CC: Michel Lespinasse <walken@google.com>,
        =?utf-8?B?w4ltZXJpYyBNYXNjaGlubw==?= <emeric.maschino@gmail.com>,
        Patrick Baggett <baggett.patrick@gmail.com>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [regression] Re: [PATCH 2/3] futex: Sanitize
 cmpxchg_futex_value_locked API
Thread-Topic: [regression] Re: [PATCH 2/3] futex: Sanitize
 cmpxchg_futex_value_locked API
Thread-Index: AQHM+mMa60fd+Qk36EG3ZjMoKs1tHZZcV0Nw
Date: Mon, 5 Mar 2012 23:21:53 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F041A65@ORSMSX104.amr.corp.intel.com>
References: <20110307021127.GB31188@google.com>
 <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
 <20110309112550.GA3050@google.com>
 <alpine.LFD.2.00.1103101948540.2787@localhost6.localdomain6>
 <20110311021654.GA26122@google.com> <20110311024851.GC26122@google.com>
 <20120305000112.GA27512@burratino>
In-Reply-To: <20120305000112.GA27512@burratino>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q25NMFxp003560

> It doesn't look like the return value (r8) is actually being set beyond
> initialized to 0. If there is some ia64 instruction that modifies it, GCC
> doesn't know about it from the inline assembly (r8 doesn't appear in the
> inputs/outputs list). From looking at the x86 version (agh, inline asm is
> hard to parse), it does modify the return value based on whether the
> comparison was a success or not, and the return value is certainly used by
> the callers.

The commit comment for the change makes it sound like the return value
is an error code (-ENOSYS if the function isn't implemented/configured;
-EFAULT if the user address is bogus) - or zero if nothing bad happened.

Not "the comparison was a success or not".

What's the real answer? The ia64 code is returning 0 regardless of whether the
compare/exchange found the old value or not.  Is this a bad assumption?

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
