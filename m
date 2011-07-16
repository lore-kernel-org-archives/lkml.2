Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1GPU2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 16:28:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57569 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1GPU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 16:28:08 -0400
Date: Sat, 16 Jul 2011 21:27:53 +0100
From: Matthew Garrett <mjg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jarod Wilson <jwilson@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH] Replace a function call chain of
 kmsg_dump(KMSG_DUMP_KEXEC) with static function calls
Message-ID: <20110716202753.GA16161@srcf.ucam.org>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C17AAE59A@USINDEVS01.corp.hds.com>
 <m14o2mjj5l.fsf@fess.ebiederm.org>
 <20110716162805.GA13127@srcf.ucam.org>
 <m1hb6mgf3w.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hb6mgf3w.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 01:11:47PM -0700, Eric W. Biederman wrote:

> Without some real understanding of what is going on I'm not inclined
> to meet any of this half way and summarily reject every change to
> the kexec on panic code path.

There are platforms that simply refuse to correctly function with a 1:1 
physical/virtual mapping. But that's not the point here - this patch 
simply hardcodes saving dmesg to an EFI variable rather than using 
kmsg_dump and pstore in order to avoid handling the locking, and does 
nothing whatsoever to change the amount of EFI code involved.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
