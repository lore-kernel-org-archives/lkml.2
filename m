Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab1JCWxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 18:53:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:17014 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1JCWxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 18:53:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,481,1312182000"; 
   d="scan'208";a="74071763"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "crash-utility@redhat.com" <crash-utility@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "tachibana@mxm.nes.nec.co.jp" <tachibana@mxm.nes.nec.co.jp>,
        "oomichi@mxs.nes.nec.co.jp" <oomichi@mxs.nes.nec.co.jp>
Date: Mon, 3 Oct 2011 15:53:09 -0700
Subject: RE: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Thread-Topic: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Thread-Index: AcyBtLaSOuFif14aR8Sx7lkh2xP7rAAaZgJQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE594D4C@orsmsx505.amr.corp.intel.com>
References: <20111003070735.GJ2223@in.ibm.com>
	<20111003073203.GA22694@in.ibm.com> <m162k64c7w.fsf@fess.ebiederm.org>
In-Reply-To: <m162k64c7w.fsf@fess.ebiederm.org>
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

> It totally doesn't make sense to do this in the kernel when we can
> filter this from userspace just fine.

Patch 1 is the kernel part that provides the clue for user space
tools to do this filtering.  The other three parts are patches to
tools that see the hint and act on it.

Eric: Do you see a better way for the kernel that just crashed from
a machine check to communicate the reason for the crash to the
successor kernel?  The Elf-note in vmcore needs quite a bit of
code to set up - but is otherwise fairly succinct.  We don't want
the successor kernel to have to poke through too much memory from
the crashed kernel to figure this out - the more we look at, the
higher the probability that we step on the landmine that crashed
the original kernel.

-Tony
