Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab2APS1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:27:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:64221 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736Ab2APS1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:27:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="99191737"
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "gouders@et.bocholt.fh-gelsenkirchen.de" 
	<gouders@et.bocholt.fh-gelsenkirchen.de>,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        "justinmattock@gmail.com" <justinmattock@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
        "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: RE: x86/mce: machine check warning during poweroff
Thread-Topic: x86/mce: machine check warning during poweroff
Thread-Index: AQHMz/OlOc7kfDtuEUKAYzibjjPRa5YJUWqAgAH3DQCAACx1gIAABziAgAAKkwCAACuJgIAAAzoAgADINQCAA10WgP//fHYw
Date: Mon, 16 Jan 2012 18:27:16 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F01C672@ORSMSX104.amr.corp.intel.com>
References: <20120111000051.GA28874@dztty>
 <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com>
 <4F10929E.8070007@linux.vnet.ibm.com>
 <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
 <4F10BDF7.8030306@linux.vnet.ibm.com>
 <CA+55aFyD=9MZCyo-Tq0J7g2p9Qvp=S+GADpUfoQ0dcde_bvzSg@mail.gmail.com>
 <4F10EB5B.5060804@linux.vnet.ibm.com>
 <CA+55aFxK5XCh6NCbo9AMvsarS9_A+s0QqV6=vC2O4dgg3vg=Aw@mail.gmail.com>
 <20120114144938.GA32033@suse.de> <20120116181135.GA2680@suse.de>
In-Reply-To: <20120116181135.GA2680@suse.de>
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

> The "correct" way to fix this up would be to have a per-cpu structure
> for all of the different mce things that are created in this driver
> (struct device, struct mce, exception counts, work queues, polling
> banks, etc.), but that seems pretty messy, and I imagine some of these
> want to stay as-is for some performance issues.  As I don't know this
> code at all, I'm a bit leary to make that kind of change.

If you get so many machine checks that you care about the performance
of the handler - you may be worrying about the wrong things.

I'm more concerned about maintainability of the code. Seto-san has
submitted many patches re-grouping the functions inside mce.c into
functional areas - keeping the data structures separated makes
sense - especially if there is some goal of splitting mce.c into
separate files.

-Tony
