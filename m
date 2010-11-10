Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab0KJRun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:50:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:57693 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab0KJRul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:50:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,179,1288594800"; 
   d="scan'208";a="856204005"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mchehab@redhat.com" <mchehab@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 10 Nov 2010 09:50:37 -0800
Subject: RE: [RFC/Requirements/Design] h/w error reporting
Thread-Topic: [RFC/Requirements/Design] h/w error reporting
Thread-Index: AcuA/pN8C51G+oB5R3a6sAhU9NyaLgAALpUA
Message-ID: <987664A83D2D224EAE907B061CE93D5301649A6EAC@orsmsx505.amr.corp.intel.com>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
 <20101110101450.GA18481@elte.hu>
 <1289400056.12418.139.camel@gandalf.stny.rr.com>
 <1289400234.2191.129.camel@laptop>
 <1289401781.12418.145.camel@gandalf.stny.rr.com>
 <1289403019.2084.17.camel@laptop>
 <1289407960.12418.169.camel@gandalf.stny.rr.com>
 <20101110170559.GA15704@a1.tnic> <20101110174122.GA4001@elte.hu>
In-Reply-To: <20101110174122.GA4001@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We could even have some (small) statically enabled build-time
> buffer that could be enabled straight away before any allocators
> are enabled.

Agreed - in fact the error reporting paths will also want
some pre-allocated guaranteed space at all times.  Allocating
memory from within an NMI or Machine Check handler would
cause too many problems.

-Tony
