Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031277Ab2B2R2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:28:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:4108 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031239Ab2B2R2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:28:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="131072595"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@amd64.org>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Topic: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Thread-Index: AQHM9jOzRSobI8iWIk6i7fpsFGO9fZZTmLGAgACV04CAAB/YAP//0NAw
Date: Wed, 29 Feb 2012 17:20:35 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F040162@ORSMSX104.amr.corp.intel.com>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com> <20120229101047.GA21224@aftab>
 <4F4E145E.4040901@redhat.com>
In-Reply-To: <4F4E145E.4040901@redhat.com>
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

> IMHO, before removing those fields, it would be better to first implement
> what is there at the mcelog userspace parser for the Intel machines into
> kernelspace (or to look into its source code), and check what registers
> aren't used by either AMD 64 MCE decoder or by the Intel MCE decoder.
>
> Tony,
>
> Is there anyone at Intel working on porting it to kernelspace?

The mcelog code just looks at model specific fields in MCi_STATUS
and MCi_MISC.  We could move it to the kernel - but I don't see
much value in doing so.  In this case all the information we need
is carried in status/misc - so as long as we keep all of those
bits (and the cpu family/model) we can safely decode/analyze later.

-Tony
