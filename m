Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab2C2HDx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 03:03:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:33767 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab2C2HDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 03:03:47 -0400
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.46.74
Date: Thu, 29 Mar 2012 00:03:36 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] kvm-amd: Auto-load on CPUs with SVM.
Message-ID: <20120329070336.GA11227@leaf>
References: <20120321063350.GA3468@leaf>
 <4F72F549.6060407@redhat.com>
 <20120328183228.GA24889@leaf>
 <4F740235.7090508@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F740235.7090508@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 10:33:25AM +0400, Michael Tokarev wrote:
> On 28.03.2012 22:32, Josh Triplett wrote:
> > Enable x86 feature-based autoloading for the kvm-amd module on CPUs
> > with X86_FEATURE_SVM.
> > 
> > Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> 
> It appears to work fine on my amd boxen.

Thanks for testing it.  Can I interpret that as a Tested-by/Acked-by?

> The only problem
> is that I've no idea when it will be possible to finally
> disable the init script (shipped in Debian and other distros)
> to load the module based on /proc/cpuinfo contents.  It will
> do nothing on kernels with this (or kvm-intel) change applied,
> but we still need to support older kernels without that feature... :)

Each stable release of Debian has a specific minimum kernel version that
it supports, typically determined by the requirements of packages such
as udev.  As far as I know, the next stable release will ship with 3.2,
and I don't think the necessary infrastructure exists in 3.2 to backport
this patch (though I'd love to hear otherwise if it does), so that
release will probably need to include the init script.  However, the
next release should have no problem safely dropping it and requiring a
sufficiently new kernel.

In unstable (after the release), qemu-kvm could just go ahead and
drop the script with a NEWS.Debian entry telling people to add the
necessary module to /etc/modules if they have an older kernel.

> Josh, and I'm sure you will be the first who'll file a bugreport
> against qemu-kvm in Debian requesting the startup script to be
> removed!.. ;))

I don't know where you could possibly get that idea. ;)

- Josh Triplett
