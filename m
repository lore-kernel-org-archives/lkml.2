Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936073Ab2KAQXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 12:23:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60191 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933996Ab2KAQXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 12:23:37 -0400
Date: Thu, 1 Nov 2012 16:23:15 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Khalid Aziz <khalid@gonehiking.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, kexec@lists.infradead.org,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        horms@verge.net.au, "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Dave Young <dyoung@redhat.com>
Subject: Re: Kdump with signed images
Message-ID: <20121101162315.GA13132@srcf.ucam.org>
References: <1351214158.18115.186.camel@falcor>
 <20121026023916.GA16762@srcf.ucam.org>
 <20121026170609.GB24687@redhat.com>
 <1351276649.18115.217.camel@falcor>
 <20121101131003.GA14573@redhat.com>
 <20121101135356.GA15659@redhat.com>
 <1351780159.15708.17.camel@falcor>
 <20121101145149.GB15821@redhat.com>
 <20121101145731.GB10662@srcf.ucam.org>
 <1351782656.3782.58.camel@rhapsody>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351782656.3782.58.camel@rhapsody>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 09:10:56AM -0600, Khalid Aziz wrote:
> On Thu, 2012-11-01 at 14:57 +0000, Matthew Garrett wrote:
> > On Thu, Nov 01, 2012 at 10:51:49AM -0400, Vivek Goyal wrote:
> > 
> > > And if one wants only /sbin/kexec to call it, then just sign that
> > > one so no other executable will be able to call kexec_load(). Though
> > > I don't think that's the requirement here. Requirement is that only
> > > trusted executables should be able to call kexec_load().
> > 
> > Where "trusted executables" means "signed by a key that's present in the 
> > system firmware or in the kernel that's signed with a key that's present 
> > in the system firmware", sure.
> > 
> 
> This is starting to sound too restrictive (even though I understand the
> rationale behind the restrictions). Does this allow for a custom
> userspace application that among other things also can kexec_load() a
> new kernel and boot it, for example a customer unique health monitoring
> app that reboots the system if things are not looking right on the
> running system?

Only if it's signed with a key that the kernel trusts.

> How would a customer go about getting that userspace binary signed and 
> re-signed every time they update their app? There is the option of 
> turning the whole SecureBoot thing off for a system like that but let 
> us assume customer wants to leave that on or does not have the option 
> to turn it off?

There's ongoing work for providing mechanisms for trusting user keys. If 
you want Secure Boot turned on, you don't want any untrusted code 
running in your kernel. If you're happy with untrusted code in your 
kernel, why are you using Secure Boot?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
