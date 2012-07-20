Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2GTO3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 10:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab2GTO3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 10:29:45 -0400
Date: Fri, 20 Jul 2012 10:29:34 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH v2 2/3] Hold multiple logs
Message-ID: <20120720142934.GF5637@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB27FDC@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA5F@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28056@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EA97@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB2813D@USINDEM103.corp.hds.com>
 <3908561D78D1C84285E8C5FCA982C28F1936EADE@ORSMSX104.amr.corp.intel.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB28206@USINDEM103.corp.hds.com>
 <20120720030328.GC5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40FB286FB@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D40FB286FB@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 01:24:38PM +0000, Seiji Aguchi wrote:
> 
> > What is the harm of not using this and just letting the number be infinite (or until EFI runs out of space)?  Is it a big deal if extra failures
> > are logged?
> 
> 
> There may be someone using NVRAM for other purposes.
> Actually, we have the user interface, /sys/firmware/efi/vars/new_vars, del_vars.
> 
> In this case, they want to avoid filling with unneeded logs. 

Sure, which is why it needs to be cleaned out regularly.  This isn't much
different than with /var/logs or even /boot.  The former can suck up lots
of disk space for no reason and the later can use up limited space if you
install to many kernels.

I don't know, I am not a fan of this policy in the kernel, I would rather
keep it simple, like an on/off switch.  If you decide you want to use efi
for logging than you better make sure you have an app to clean it up.
Otherwise the user shouldn't turn it on.

Creating rules like this seems to be complicating things to me IMHO.  But
I will gladly defer to someone else's judgement.

Cheers,
Don

> 
> > The hope would be a daemon would clear the old logs out and you never run out of space.
> 
> In most case
> But as Tony mentioned, NVRAM may be filled with multiple oops even if we have the daemon.
> 
> Seiji
