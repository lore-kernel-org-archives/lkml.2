Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169Ab2JYSzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:55:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934816Ab2JYSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:55:33 -0400
Date: Thu, 25 Oct 2012 14:55:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Kdump with signed images
Message-ID: <20121025185520.GA17995@redhat.com>
References: <877gqnnnf0.fsf@xmission.com>
 <20121019143112.GB27052@redhat.com>
 <871ugqb4gj.fsf@xmission.com>
 <20121023131854.GA16496@redhat.com>
 <20121023145920.GD16496@redhat.com>
 <87fw552mb4.fsf_-_@xmission.com>
 <20121024173651.GE1821@redhat.com>
 <1351145401.18115.78.camel@falcor>
 <20121025141048.GD9377@redhat.com>
 <1351190421.18115.92.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351190421.18115.92.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:40:21PM -0400, Mimi Zohar wrote:
> On Thu, 2012-10-25 at 10:10 -0400, Vivek Goyal wrote:
> > On Thu, Oct 25, 2012 at 02:10:01AM -0400, Mimi Zohar wrote:
> > 
> > [..]
> > > IMA-appraisal verifies the integrity of file data, while EVM verifies
> > > the integrity of the file metadata, such as LSM and IMA-appraisal
> > > labels.  Both 'security.ima' and 'security.evm' can contain digital
> > > signatures.
> > 
> > But the private key for creating these digital signature needs to be
> > on the target system?
> > 
> > Thanks
> > Vivek
> 
> Absolutely not.  The public key needs to be added to the _ima or _evm
> keyrings.  Roberto Sassu modified dracut and later made equivalent
> changes to systemd.  Both have been upstreamed.

Putting public key in _ima or _evm keyring is not the problem. This is
just the verification part.

> Dmitry has a package
> that labels the filesystem called ima-evm-utils, which supports hash
> (IMA), hmac(EVM) and digital signatures(both).
> 
> We're hoping that distro's would label all immutable files, not only elf
> executables, with digital signatures and mutable files with a hash.

So this labeling (digital signing) can happen at build time?

I suspect you need labeling to happen at system install time? If yes,
installer does not have the private key to sign anything.

IOW, if distro sign a file, they will most likely put signatures in
ELF header (something along the lines of signing PE/COFF binaries). But
I think you need digital signatures to be put in security.ima which are
stored in xattrs and xattrs are not generated till you put file in
question on target file system.

Thanks
Vivek
