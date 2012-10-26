Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab2JZRGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 13:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab2JZRGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 13:06:32 -0400
Date: Fri, 26 Oct 2012 13:06:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Kdump with signed images
Message-ID: <20121026170609.GB24687@redhat.com>
References: <20121023131854.GA16496@redhat.com>
 <20121023145920.GD16496@redhat.com>
 <87fw552mb4.fsf_-_@xmission.com>
 <20121024173651.GE1821@redhat.com>
 <1351145401.18115.78.camel@falcor>
 <20121025141048.GD9377@redhat.com>
 <1351190421.18115.92.camel@falcor>
 <20121025185520.GA17995@redhat.com>
 <1351214158.18115.186.camel@falcor>
 <20121026023916.GA16762@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026023916.GA16762@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 03:39:16AM +0100, Matthew Garrett wrote:
> On Thu, Oct 25, 2012 at 09:15:58PM -0400, Mimi Zohar wrote:
> 
> > On a running system, the package installer, after verifying the package
> > integrity, would install each file with the associated 'security.ima'
> > extended attribute.  The 'security.evm' digital signature would be
> > installed with an HMAC, calculated using a system unique key. 
> 
> The idea isn't to prevent /sbin/kexec from being modified after 
> installation - it's to prevent it from being possible to install a 
> system that has a modified /sbin/kexec. Leaving any part of this up to 
> the package installer means that it doesn't solve the problem we're 
> trying to solve here. It must be impossible for the kernel to launch any 
> /sbin/kexec that hasn't been signed by a trusted key that's been built 
> into the kernel, and it must be impossible for anything other than 
> /sbin/kexec to make the kexec system call.

I am kind of lost now so just trying to summarize whatever I have
learned so far from this thread.

- So say we can sign /sbin/kexec at build time and distros can do that.
- Verify the signature at exec time using kernel keyring and if
  verification happens successfully, say process gains extra capability.
- Use this new capability to determine whether kexec_load() will be
  successful or not.

Even if we can do all this, it still has the issue of being able to
stop the process in user space and replace the code at run time
and be able to launch unsigned kernel.

So until and unless we have a good solution to verify application's
integrity/authneticity at the time of kexec_load() system call we
still have the problem. And I don't think we have come up with a
solution for that yet (until and unless I missed something).
  
Thanks
Vivek
