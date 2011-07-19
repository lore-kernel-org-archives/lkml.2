Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab1GSTkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:40:45 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:56177 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab1GSTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:40:44 -0400
Date: Tue, 19 Jul 2011 20:40:36 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH -mmotm 1/4] Add static function calls of pstore to
 kexec path
Message-ID: <20110719194036.GA25558@srcf.ucam.org>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C3@USINDEVS01.corp.hds.com>
 <20110719183506.GA23770@srcf.ucam.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C199C64D6@USINDEVS01.corp.hds.com>
 <20110719185213.GA24420@srcf.ucam.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C199C64E5@USINDEVS01.corp.hds.com>
 <20110719192754.GA25268@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719192754.GA25268@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 08:27:54PM +0100, Matthew Garrett wrote:
> On Tue, Jul 19, 2011 at 03:14:22PM -0400, Seiji Aguchi wrote:
> > 
> > >And how does that handle the case where we're halfway through a pstore
> > >access when the NMI arrives? ERST, at least, has a complex state
> > >machine. You can't guarantee what starting one transaction without
> > >completing one that was in process will do.
> > 
> > As for ERST, write access is protected by raw_spin_trylock_irqsave(&erst_lock).
> > Are there anything I'm missing?
> 
> If there's already locking involved, what benefit does removing the lock 
> in the pstore code give? You'll just hang when you hit the erst code 
> instead of the pstore code.

I'm sorry, you're right, this is a trylock so we won't hang in this 
case. We should probably document that in the pstore documentation to 
ensure that any future backends have the same behaviour.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
