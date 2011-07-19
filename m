Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab1GSTUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1GSTUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:20:44 -0400
Date: Tue, 19 Jul 2011 15:20:25 -0400
From: Don Zickus <dzickus@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, Matthew Garrett <mjg@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to
 kexec path
Message-ID: <20110719192025.GB3400@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C3@USINDEVS01.corp.hds.com>
 <20110719183506.GA23770@srcf.ucam.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C199C64D6@USINDEVS01.corp.hds.com>
 <20110719185411.GA3400@redhat.com>
 <20110719190212.GA4844@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719190212.GA4844@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 03:02:12PM -0400, Vivek Goyal wrote:
> > Another interesting question is do we need to log anything in the kdump
> > path?  Isn't kdump generating the same info?  What added value do we get
> > over kdump?
> 
> I had the same question. The argument is that kdump can fail and they
> can not afford to not capture any info at all. So before kdump executes
> they want to save some state to NVRAM.
> 
> I am wondering that saving this info to NVRAM, can it be done early in
> second kernel? I guess we are not supposed to take any EFI services in
> second kernel so it might not be possible.

Actually the write to NVRAM wouldn't be so bad if ERST supported it.  It
would just be an equvialent to a memcpy.  Currently it uses a complicated
state machine to a persistent storage which complicates things.  As a
result I get nervous if ERST firmware issues would block us from executing
kdump.

Cheers,
Don
