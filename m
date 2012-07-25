Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193Ab2GYSh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:37:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:33555 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab2GYShY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:37:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="126842525"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>
CC: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] ia64: rename platform_* to ia64_platform_*
Thread-Topic: [PATCH] ia64: rename platform_* to ia64_platform_*
Thread-Index: AQHNamsDWsJ/H/XFkUG/OCkOK840Jpc6UjDg
Date: Wed, 25 Jul 2012 18:37:22 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1937113E@ORSMSX104.amr.corp.intel.com>
References: <20120725080653.GA18233@localhost>
 <1343204319.1693.6.camel@joe2Laptop> <20120725133950.GA30512@localhost>
In-Reply-To: <20120725133950.GA30512@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Is platform_name particularly special?

Yes. It is the symbol that is currently colliding with other subsystem namespace.

>> Perhaps it's be better to rename all the other
>> platform_<foo> uses to ia64_platform_<foo>
>
> That's good point in general, oh well I just wanted to make the minimal change..

Following that logic there isn't anything special about symbols starting with
"platform" ... and we should hunt down every global symbol in every architecture
that is local to the architecture and replace it with $arch_$symbol.

I think I'll just take the minimal patch to fix "platform_name" and continue to
use a "fix as problems occur" algorithm to the namespace pollution problem.

-Tony

