Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab2JYSmt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:42:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57942 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098Ab2JYSms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:42:48 -0400
Message-ID: <1351190421.18115.92.camel@falcor>
Subject: Re: Kdump with signed images
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Date: Thu, 25 Oct 2012 14:40:21 -0400
In-Reply-To: <20121025141048.GD9377@redhat.com>
References: <874nlrv2ni.fsf@xmission.com>
	 <20121019020630.GA27052@redhat.com> <877gqnnnf0.fsf@xmission.com>
	 <20121019143112.GB27052@redhat.com> <871ugqb4gj.fsf@xmission.com>
	 <20121023131854.GA16496@redhat.com> <20121023145920.GD16496@redhat.com>
	 <87fw552mb4.fsf_-_@xmission.com> <20121024173651.GE1821@redhat.com>
	 <1351145401.18115.78.camel@falcor> <20121025141048.GD9377@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102518-5406-0000-0000-0000016BB700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 10:10 -0400, Vivek Goyal wrote:
> On Thu, Oct 25, 2012 at 02:10:01AM -0400, Mimi Zohar wrote:
> 
> [..]
> > IMA-appraisal verifies the integrity of file data, while EVM verifies
> > the integrity of the file metadata, such as LSM and IMA-appraisal
> > labels.  Both 'security.ima' and 'security.evm' can contain digital
> > signatures.
> 
> But the private key for creating these digital signature needs to be
> on the target system?
> 
> Thanks
> Vivek

Absolutely not.  The public key needs to be added to the _ima or _evm
keyrings.  Roberto Sassu modified dracut and later made equivalent
changes to systemd.  Both have been upstreamed.  Dmitry has a package
that labels the filesystem called ima-evm-utils, which supports hash
(IMA), hmac(EVM) and digital signatures(both).

We're hoping that distro's would label all immutable files, not only elf
executables, with digital signatures and mutable files with a hash.

thanks,

Mimi

