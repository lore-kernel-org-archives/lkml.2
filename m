Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab2LLVtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:49:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:26647 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755222Ab2LLVtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:49:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,269,1355126400"; 
   d="scan'208";a="256630603"
From: "Luck, Tony" <tony.luck@intel.com>
To: Joe Perches <joe@perches.com>, Borislav Petkov <bp@alien8.de>
CC: Jiri Kosina <trivial@kernel.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>
Subject: RE: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
Thread-Topic: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
Thread-Index: AQHN2JWuJhzxrbBlck6Q60HFWLHCKZgWLweAgAAFm4D//31+MA==
Date: Wed, 12 Dec 2012 21:49:39 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C969495@ORSMSX108.amr.corp.intel.com>
References: <cover.1355335227.git.joe@perches.com>
	 <054f8a88fe46ae0b4c2669d0e155d84c11b66115.1355335228.git.joe@perches.com>
	 <20121212210959.GH8760@liondog.tnic> <1355347803.8538.16.camel@joe-AO722>
In-Reply-To: <1355347803.8538.16.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think I'd go ahead and ACK this unless Tony has some comments. I'm not
> happy about the two pr_emerg calls based on the conditional.

As written the patch has the nice property of not making any changes to the
console output (except to eliminate the possibility of interleaved output that
the original code had).  Whereas making the change you suggest would end
up with a useless "{}" in the usermode case (or worse if %pSR did something
with m->ip .. which is most probably not NULL ... it should be a valid user mode
instruction pointer when m->cs != KERNEL_CS).

So Acked-by: Tony Luck <tony.luck@intel.com>

