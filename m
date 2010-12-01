Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101Ab0LATiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:38:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:48591 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab0LATiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:38:02 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <20101201162335.GB2511@redhat.com>
References: <4CF60095.1020900@kernel.org> <1291202867.4023.3.camel@twins>
	 <20101201160640.GA2511@redhat.com> <1291219906.32004.1671.camel@laptop>
	 <20101201162335.GB2511@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 20:38:12 +0100
Message-ID: <1291232292.32004.1969.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 11:23 -0500, Vivek Goyal wrote:
> > What does kexec normally do to ensure hardware is left in a sane state?
> 
> Typically calls device_shutdown() and sysdev_shutdown() from
> kernel_restart_prepare() to shutdown the devices.
> 
> Also calls machine_shutdown() which depending on architecture can take
> care of various things like stopping other cpus, shutting down LAPIC, 
> disabling IOAPIC, disabling hpet, shutting down IOMMU etc
> (native_machine_shutdown()). 

So basically there's no sane generic reset callout?
