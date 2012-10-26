Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab2JZCkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 22:40:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:46156 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2JZCkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 22:40:06 -0400
Date: Fri, 26 Oct 2012 03:39:16 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Khalid Aziz <khalid@gonehiking.org>, kexec@lists.infradead.org,
        horms@verge.net.au, Dave Young <dyoung@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Roberto Sassu <roberto.sassu@polito.it>,
        Kees Cook <keescook@chromium.org>
Subject: Re: Kdump with signed images
Message-ID: <20121026023916.GA16762@srcf.ucam.org>
References: <871ugqb4gj.fsf@xmission.com>
 <20121023131854.GA16496@redhat.com>
 <20121023145920.GD16496@redhat.com>
 <87fw552mb4.fsf_-_@xmission.com>
 <20121024173651.GE1821@redhat.com>
 <1351145401.18115.78.camel@falcor>
 <20121025141048.GD9377@redhat.com>
 <1351190421.18115.92.camel@falcor>
 <20121025185520.GA17995@redhat.com>
 <1351214158.18115.186.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351214158.18115.186.camel@falcor>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 09:15:58PM -0400, Mimi Zohar wrote:

> On a running system, the package installer, after verifying the package
> integrity, would install each file with the associated 'security.ima'
> extended attribute.  The 'security.evm' digital signature would be
> installed with an HMAC, calculated using a system unique key. 

The idea isn't to prevent /sbin/kexec from being modified after 
installation - it's to prevent it from being possible to install a 
system that has a modified /sbin/kexec. Leaving any part of this up to 
the package installer means that it doesn't solve the problem we're 
trying to solve here. It must be impossible for the kernel to launch any 
/sbin/kexec that hasn't been signed by a trusted key that's been built 
into the kernel, and it must be impossible for anything other than 
/sbin/kexec to make the kexec system call.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
