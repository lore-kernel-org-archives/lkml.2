Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1JKS7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 14:59:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:29279 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab1JKS7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 14:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="62227866"
From: "Luck, Tony" <tony.luck@intel.com>
To: "prasad@linux.vnet.ibm.com" <prasad@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "crash-utility@redhat.com" <crash-utility@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "anderson@redhat.com" <anderson@redhat.com>,
        "tachibana@mxm.nes.nec.co.jp" <tachibana@mxm.nes.nec.co.jp>,
        "oomichi@mxs.nes.nec.co.jp" <oomichi@mxs.nes.nec.co.jp>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Nick Bowler <nbowler@elliptictech.com>
Date: Tue, 11 Oct 2011 11:59:41 -0700
Subject: RE: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Thread-Topic: [Patch 1/4][kernel][slimdump] Add new elf-note of type
 NT_NOCOREDUMP to capture slimdump
Thread-Index: AcyIRd6tff70mIrRTheRScHcHMgHQAAAZF8Q
Message-ID: <987664A83D2D224EAE907B061CE93D5301EE794AEF@orsmsx505.amr.corp.intel.com>
References: <20111003070735.GJ2223@in.ibm.com>
 <20111003073203.GA22694@in.ibm.com> <20111004140437.GA28306@redhat.com>
 <20111005071844.GB2235@in.ibm.com> <20111005152537.GB30146@redhat.com>
 <20111007161218.GA2297@in.ibm.com> <20111010070725.GB11577@liondog.tnic>
 <20111011184434.GB32316@in.ibm.com>
In-Reply-To: <20111011184434.GB32316@in.ibm.com>
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

> So, in any case we may not be able to disable machine-check exceptions
> (MCEs) only within the context of kexec'ed kernel. Let me know if I've
> missed something here.

Linux sets the CR4.MCE bit - look for "set_in_cr4(X86_CR4_MCE)" for places
where it does so.  You can ask it not to do that with "mce=off" argument.

So we can control this from the OS level.

-Tony
