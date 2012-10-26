Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653Ab2JZSCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:02:42 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44601 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964973Ab2JZSCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:02:40 -0400
Message-ID: <1351274374.18115.205.camel@falcor>
Subject: Re: Kdump with signed images
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Date: Fri, 26 Oct 2012 13:59:34 -0400
In-Reply-To: <20121026023916.GA16762@srcf.ucam.org>
References: <871ugqb4gj.fsf@xmission.com>
	 <20121023131854.GA16496@redhat.com> <20121023145920.GD16496@redhat.com>
	 <87fw552mb4.fsf_-_@xmission.com> <20121024173651.GE1821@redhat.com>
	 <1351145401.18115.78.camel@falcor> <20121025141048.GD9377@redhat.com>
	 <1351190421.18115.92.camel@falcor> <20121025185520.GA17995@redhat.com>
	 <1351214158.18115.186.camel@falcor> <20121026023916.GA16762@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102618-7182-0000-0000-000002F5D04B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 03:39 +0100, Matthew Garrett wrote:
> On Thu, Oct 25, 2012 at 09:15:58PM -0400, Mimi Zohar wrote:
> 
> > On a running system, the package installer, after verifying the package
> > integrity, would install each file with the associated 'security.ima'
> > extended attribute.  The 'security.evm' digital signature would be
> > installed with an HMAC, calculated using a system unique key. 
> 
> The idea isn't to prevent /sbin/kexec from being modified after 
> installation - it's to prevent it from being possible to install a 
> system that has a modified /sbin/kexec.

Understood.

>  Leaving any part of this up to 
> the package installer means that it doesn't solve the problem we're 
> trying to solve here. It must be impossible for the kernel to launch any 
> /sbin/kexec that hasn't been signed by a trusted key that's been built 
> into the kernel, 

With Dmitry's patch "5e0d1a4 ima: added policy support for security.ima
type", or something similar, we can force 'security.ima' to a specific
type, in this case, a digital signature.  With that patch, this
shouldn't be a problem.

> and it must be impossible for anything other than 
> /sbin/kexec to make the kexec system call.

Permission is a MAC issue. :)

thanks,

Mimi


