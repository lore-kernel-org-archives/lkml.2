Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1GMQ6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 12:58:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:49673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756211Ab1GMQ6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 12:58:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,526,1304319600"; 
   d="scan'208";a="25455249"
From: "Luck, Tony" <tony.luck@intel.com>
To: Don Zickus <dzickus@redhat.com>
CC: "mjg@redhat.com" <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Date: Wed, 13 Jul 2011 09:58:18 -0700
Subject: RE: pstore dump inside an nmi handler
Thread-Topic: pstore dump inside an nmi handler
Thread-Index: AcxAqTsJNtvMBrAKS7S9yPdA9cnaYgA08VUQ
Message-ID: <987664A83D2D224EAE907B061CE93D5301E9C9F314@orsmsx505.amr.corp.intel.com>
References: <20110708201731.GA3025@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E981AB56@orsmsx505.amr.corp.intel.com>
 <20110711215541.GF2938@redhat.com> <20110712153436.GL3765@redhat.com>
In-Reply-To: <20110712153436.GL3765@redhat.com>
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

> Actually, is it expected that the ERST can handle only 8 records?  Also if
> you remove those records with pstore mount under /mnt; 'rm -rf
> /mnt/dmesg-*', are those records removed immediately or are they cached to
> be removed later?  IOW, if a did a 'rm -rf ..' and then an 'echo c >
> /proc/sysrq-trigger' immediately after it, would I expect those records to
> be removed or not?  Testing shows they are removed on reboot but the later
> 'echo c > ..' didn't save any new error records. :-/

It isn't specified how much storage will be provided by ERST.  I tried to
find a limit on the system on which I did the original development, but
got bored at a hundred ... which seemed to be plenty enough since the usual
mode of operation ought to be to copy the records from pstore to some other
storage and remove them from pstore early in boot.

The unlink from pstore is passed immediately to the backing store to
do it's clear/erase operation ... but whether the BIOS implementation
of ERST makes that space immediately available might vary from platform
to platform.

-Tony
