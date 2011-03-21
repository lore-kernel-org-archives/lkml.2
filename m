Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1CUP4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126Ab1CUP4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:56:33 -0400
Date: Mon, 21 Mar 2011 11:56:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cong Wang <amwang@redhat.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Takao Indoh <tindoh@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Len Brown <lenb@kernel.org>,
        linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Patch] acpi: introduce "acpi_addr=" parameter for kdump
Message-ID: <20110321155629.GF2694@redhat.com>
References: <1299766243-494-1-git-send-email-amwang@redhat.com>
 <20110310143923.GB29464@redhat.com>
 <m1oc5ig90b.fsf@fess.ebiederm.org>
 <20110310185019.GB23105@srcf.ucam.org>
 <4D86F2C2.9080707@redhat.com>
 <m1hbawkifj.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbawkifj.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 01:05:04AM -0700, Eric W. Biederman wrote:
> Cong Wang <amwang@redhat.com> writes:
> 
> > Eric, any comments?
> 
> You have my Nack.
> 
> We are doing stupid and unnecessary things, that cause us problems with
> EFI.  If we stop doing those stupid and unnecessary things we won't have
> problems.
> 
> So I don't see the point of adding more stupid and unnecessary work, so
> we can continue to do stupid and unnecessary things and cause ourselves
> problems.

Hi Eric,

I went through your proposal in last mail and frankly speaking I understand
very little of it (due to my lack of knowledge in this area). Had couple
of very high level thoughts though.

- Matthew raised the issue of ACPI not being complete replacement as
  reboot path uses EFI.

- I am assuming with this notion of run time services in EFI, one can
  expect more and more issues down the line where people will want to
  call into EFI. So trying to enforce this notion that never call EFI
  from kernel once kernel is booted and isolate the EFI runtime services
  to make kexec/kdump work might not be best solution.

Matthew and I were chatting in general about it couple of days back and
mattew suggested how about if we embrace the idea of booting the kernel
always in physical mode (both first and second) and keep that extra set
of pagetables around to make EFI calls. That way kexec/kdump should just
work and kernel changes also might not be too much.

The potential problem with this is that this might expose various kind
of BIOS issues with different vendors as vendors might not test the
physical path.

May be we can give it a try and see if it flies?

Thanks
Vivek 
