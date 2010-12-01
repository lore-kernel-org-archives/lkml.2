Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab0LATtg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:49:36 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59061 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab0LATtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:49:35 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <20101201194644.GD2511@redhat.com>
References: <4CF60095.1020900@kernel.org> <1291202867.4023.3.camel@twins>
	 <20101201160640.GA2511@redhat.com> <1291219906.32004.1671.camel@laptop>
	 <20101201162335.GB2511@redhat.com> <1291232292.32004.1969.camel@laptop>
	 <20101201194644.GD2511@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 20:49:49 +0100
Message-ID: <1291232989.32004.1987.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 14:46 -0500, Vivek Goyal wrote:
> On Wed, Dec 01, 2010 at 08:38:12PM +0100, Peter Zijlstra wrote:
> > On Wed, 2010-12-01 at 11:23 -0500, Vivek Goyal wrote:
> > > > What does kexec normally do to ensure hardware is left in a sane state?
> > > 
> > > Typically calls device_shutdown() and sysdev_shutdown() from
> > > kernel_restart_prepare() to shutdown the devices.
> > > 
> > > Also calls machine_shutdown() which depending on architecture can take
> > > care of various things like stopping other cpus, shutting down LAPIC, 
> > > disabling IOAPIC, disabling hpet, shutting down IOMMU etc
> > > (native_machine_shutdown()). 
> > 
> > So basically there's no sane generic reset callout?
> 
> I think ->shutdown() calls are sane generic callouts. Isn't it?

->shutdown looks like it's about to reset/halt the hardware, no point in
slowing down the regular shutdown/reboot path for something like this,
we know the hardware will get reset to a sane state.

> There seem to be few exceptions for LAPIC, IOMMU and HPET and I am not
> sure why they are not covered by shutdown calls. CCing Eric, he might
> have more insight into it.

That's all arch specific, but even there I don't think the reset code
should live outside of kexec.
