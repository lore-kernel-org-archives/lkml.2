Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2GYSXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:23:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:63231 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423Ab2GYSXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:23:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171371454"
From: "Luck, Tony" <tony.luck@intel.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Helge Deller <deller@gmx.de>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: RE: [PATCH] debug: Do not permit CONFIG_DEBUG_STACK_USAGE=y on IA64
 or PARISC
Thread-Topic: [PATCH] debug: Do not permit CONFIG_DEBUG_STACK_USAGE=y on
 IA64 or PARISC
Thread-Index: AQHNajlvcu1EraYsb06urUq7jiT5f5c6GJAAgAA1z4A=
Date: Wed, 25 Jul 2012 18:23:01 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19371120@ORSMSX104.amr.corp.intel.com>
References: <4a613b26cc402fb3ed8130cd07a37e76f4c133ef.1342634029.git.tony.luck@intel.com>
	 <20120725074501.GB27950@gmail.com> <1343203348.3139.16.camel@dabdike>
In-Reply-To: <1343203348.3139.16.camel@dabdike>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6PINT5l017140

> Since the problem is an invalid assumption about how the stack grows,
> why not just condition it on that.  We actually have a config option for
> this: CONFIG_STACK_GROWSUP.  But for some reason ia64 doesn't define
> this, why not, Tony?  It looks deliberate because you have replaced a
> lot of
>
> #ifdef CONFIG_STACK_GROWSUP
>
> with
>
> #if defined(CONFIG_STACK_GROWSUP) || defined(CONFIG_IA64)
>
> but not all of them.

ia64 is special - we have stacks that grow both upwards and downwards!

The typical "C" stack for local function variables that need to be allocated in
memory (arrays, structures, things we take the address of, things that just
don't fit because we run out of registers) grows downwards. But local
variables assigned to registers get quietly saved away to an upwards growing
stack by the register stack engine (working somewhat asynchronously from
the cpu).l

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
