Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853Ab1GSSy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 14:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1GSSy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 14:54:28 -0400
Date: Tue, 19 Jul 2011 14:54:11 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
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
Message-ID: <20110719185411.GA3400@redhat.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64C3@USINDEVS01.corp.hds.com>
 <20110719183506.GA23770@srcf.ucam.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C199C64D6@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C199C64D6@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 02:48:22PM -0400, Seiji Aguchi wrote:
> >How is this safe? What happens if there's a pstore access in process
> >when you hit this codepath?
> 
> This will never happen because pstore_kmsg_dump_in_interrupt() is called after machine_crash_shutdown().
> 
> Panicked cpu sends NMI to all other cpus in machine_crash_shutdown() and they stop.
> 
> 
> @@ -1081,6 +1083,7 @@ void crash_kexec(struct pt_regs *regs)
>  			crash_setup_regs(&fixed_regs, regs);
>  			crash_save_vmcoreinfo();
>  			machine_crash_shutdown(&fixed_regs);
> +			pstore_kmsg_dump_in_interrupt(KMSG_DUMP_KEXEC);
> 
> Seiji

Another interesting question is do we need to log anything in the kdump
path?  Isn't kdump generating the same info?  What added value do we get
over kdump?

Cheers,
Don
