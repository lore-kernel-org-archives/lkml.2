Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab2GRCDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 22:03:21 -0400
Received: from ozlabs.org ([203.10.76.45]:54697 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012Ab2GRCDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 22:03:12 -0400
Message-ID: <1342576992.25827.3.camel@concordia>
Subject: Re: [RFC/PATCH] Use kernel supplied MMU info for kvm tool
From: Michael Ellerman <michael@ellerman.id.au>
To: Matt Evans <matt@ozlabs.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org,
        kvm-ppc@vger.kernel.org, prerna@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>
Date: Wed, 18 Jul 2012 12:03:12 +1000
In-Reply-To: <3e2231e9bf466549d1f9b12359f2f8f6@ozlabs.org>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
	 <3e2231e9bf466549d1f9b12359f2f8f6@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-17 at 10:33 +0100, Matt Evans wrote:
> Hi Michael,
> 
> On 2012-07-17 06:00, Michael Ellerman wrote:
> 
> > This is a series for kvmtool that uses a newish kernel API to get
> > MMU info, which is then fed to the guest.
> >
> > Currently we just make a good guess based on the PVR, but that is
> > potentially flakey in a few ways. The most notable is that if you 
> > don't
> > specify hugepages we don't boot - because the guest is told we 
> > support
> > 16M pages, but we don't really (on HV).
> 
> Just had a look, all good.  Thanks for tidying some old FIXMEs, 
> especially the page/segment DT props encoding grot -- and the designated 
> inits in the cpuinfo struct, whew, I heard the scream on IRC.  Sorry. 
> ;-)

Thanks Matt, no worries about the grot, there was no better way when you
wrote the original code.

The lack of designated inits did bite me quite well, while bisecting I
accidentally dropped the hunk that updated the struct definition but
kept the hunk that changed the initialisation - leading to a VM with a
slb size of 512000000 (tb_freq) etc. :)

cheers

