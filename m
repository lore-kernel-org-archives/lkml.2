Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab2FZJNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:13:22 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:24478 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2FZJNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:13:20 -0400
Date: Tue, 26 Jun 2012 11:13:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, JBeulich@suse.com,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpufeature:   Rename X86_FEATURE_DTS to 
 X86_FEATURE_DTHERM
Message-ID: <20120626111306.762c4b40@endymion.delvare>
In-Reply-To: <4FE77A6C.3050908@zytor.com>
References: <4FE34BCB.5050305@linux.intel.com>
	<tip-3bac8715443fc83413e221a5cd9d5cf3d82b79b4@git.kernel.org>
	<20120624214908.4177fc4a@endymion.delvare>
	<4FE77A6C.3050908@zytor.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2012 13:37:00 -0700, H. Peter Anvin wrote:
> On 06/24/2012 12:49 PM, Jean Delvare wrote:
> >>
> >> Therefore, rename this to "dtherm".
> >
> > I see the rationale for changing the string in /proc/cpuinfo, and
> > "dtherm" is reasonably good. I fail to see the rationale for changing
> > the X86_FEATURE_ name though, this is an API change we don't need. Plus
> > X86_FEATURE_DTS has the merit of naming the feature the way it is
> > commonly done in technical documentation, so readers know exactly what
> > it refers too, which isn't the case of DTHERM. So can we please stick
> > to X86_FEATURE_DTS?
> 
> Except that *really* seems like begging for similar problems in the future.

With your other patch to catch such collisions, I think we should be
just safe from now on?

> >> This conflict went into mainline via the hwmon tree without any x86
> >> maintainer ack, and without any kind of hint in the subject.
> >>
> >>      a4659053 x86/hwmon: fix initialization of coretemp
> >
> > All 3 x86 maintainers were Cc'd, none commented. And you know fairly
> > well why the patch went through the hwmon tree. So please stop the
> > finger-pointing. It's unfortunate that it happened, but it did, and we
> > try to fix it now, period.
> >
> >> Reported-by: Jean Delvare <khali@linux-fr.org>
> >> Link: http://lkml.kernel.org/r/4FE34BCB.5050305@linux.intel.com
> >> Cc: Jan Beulich <JBeulich@suse.com>
> >> Cc: <stable@vger.kernel.org> v2.6.36..v3.4
> >
> > No Signed-off-by?
> >
> > Not sure why you want this to go to stable trees?
> >
> 
> I think we want to minimize the ABI divergence here.

The ABI divergence already exists and will have to be dealt with
anyway. All you're doing by pushing the changes to stable trees is
making its shape more complex, and increasing the risk of conflict.
Such a conflict already happened, BTW...

-- 
Jean Delvare
