Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2IGP7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:59:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33452 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2IGP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:59:19 -0400
Date: Fri, 7 Sep 2012 11:48:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Stefan Bader <stefan.bader@canonical.com>, Matt Wilson <msw@amazon.com>,
        "Justin M. Forbes" <jmforbes@linuxtx.org>, xen-devel@lists.xen.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
Message-ID: <20120907154827.GA6059@phenom.dumpdata.com>
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
 <504A05B00200007800099C7B@nat28.tlf.novell.com>
 <5049F4E9.9050306@canonical.com>
 <504A1A950200007800099D4C@nat28.tlf.novell.com>
 <20120907142251.GA20096@linuxtx.org>
 <504A32800200007800099E40@nat28.tlf.novell.com>
 <504A172B.5020005@canonical.com>
 <504A347B0200007800099E92@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504A347B0200007800099E92@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 04:52:59PM +0100, Jan Beulich wrote:
> >>> On 07.09.12 at 17:47, Stefan Bader <stefan.bader@canonical.com> wrote:
> > On 07.09.2012 17:44, Jan Beulich wrote:
> >> All of this still doesn't provide evidence that a plain upstream
> >> kernel is actually having any problems in the first place. Further,
> >> if you say EC2 has a crippled hypervisor patch - is that patch
> >> available for looking at somewhere?
> > 
> > It was not a hypervisor patch. It was one for the guest. This was the hack:
> 
> So then why do you want to patch the upstream kernel? It won't
> make that hack go away, nor will it help any existing kernels.

It will make both distro ditch that patch - and instead they can use this.
[As we can ask them to ditch their crippled patch and they can rest
safely knowing that the upstream kernel has a quirk workaround for what
they had been hitting for ages]

Also with this patch any upstream kernel that runs on Amazon EC2 will not
run in-to the issue that Fedora and Canonical ran with an virgin kernel
when they were deploying it first time. The Amazon EC2 guidelines have it
spelled out somewhere that one can't depend on certain things  - even if
they are detected. This was one of them, and MWAIT I believe was the other.

It won't fix existing kernels - that is true but that is not what the
purpose of this patch is.

> 
> Jan
