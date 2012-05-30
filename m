Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab2E3O4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:56:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39271 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab2E3O4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:56:52 -0400
Date: Wed, 30 May 2012 10:49:29 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Beulich <JBeulich@suse.com>, Andre Przywara <andre.przywara@amd.com>,
        Jacob Shin <Jacob.Shin@amd.com>, mingo@elte.hu, jeremy@goop.org,
        tglx@linutronix.de, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530144929.GH3207@phenom.dumpdata.com>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <4FC649790200007800086E51@nat28.tlf.novell.com>
 <4FC631F0.9080109@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC631F0.9080109@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 07:42:56AM -0700, H. Peter Anvin wrote:
> On 05/30/2012 07:23 AM, Jan Beulich wrote:
> > 
> > I see - the Xen code blindly overwrites pv_cpu_ops, despite not
> > having initialized all members. That's an obvious oversight of the
> > patch that introduced the _regs variants.
> > 
> > Plus having secondary instances of things like rdmsrl_amd_safe()
> > in asm/paravirt.h seems pretty strange an approach (which was
> > why initially I didn't spot how a crash could happen there) - only
> > the lowest level functions should get re-implemented here.
> > 
> 
> This kinds of things are part of why Xen makes me want to cry regularly.

It looks like an oversight by Borislav (177fed1ee8d727c39601ce9fc2299b4cb25a718e
and 132ec92f) and Yinghai (b05f78f5c713eda2c34e495d92495ee4f1c3b5e1) where
they added these wrappers way back in 2009!
