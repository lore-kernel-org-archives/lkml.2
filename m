Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366Ab0LHTSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:18:09 -0500
Received: from canuck.infradead.org ([134.117.69.58]:51303 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab0LHTSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:18:06 -0500
Subject: Re: perf hw  in kexeced kernel broken in tip
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Haren Myneni <hbabu@us.ibm.com>
In-Reply-To: <4CFFD715.4090900@kernel.org>
References: <1291234036.32004.2008.camel@laptop>
	 <m162vdp3l4.fsf@fess.ebiederm.org> <20101202052321.GH18100@redhat.com>
	 <1291275270.4023.20.camel@twins> <20101202161502.GL18100@redhat.com>
	 <1291764620.2032.1293.camel@laptop> <20101208140103.GM21786@redhat.com>
	 <1291818005.28378.38.camel@laptop> <1291820356.28378.83.camel@laptop>
	 <4CFFD1C2.1080108@kernel.org> <20101208190158.GA8565@redhat.com>
	 <4CFFD715.4090900@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 08 Dec 2010 20:17:35 +0100
Message-ID: <1291835855.28378.149.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 11:05 -0800, Yinghai Lu wrote:
> On 12/08/2010 11:01 AM, Don Zickus wrote:
> > On Wed, Dec 08, 2010 at 10:43:14AM -0800, Yinghai Lu wrote:
> >>
> >> can you add sth force_... in command line to take over ownership of perf from BIOS or previous kernel ?
> >>
> >> then still can use perf etc after we kexec from RHEL or SLES kernel to later kernel ( from 2.6.37)
> > 
> > My understand is that you can't because the BIOS is actively using it
> > behind the scenes of the kernel (well during an SMI).  I have a machine
> > where I tried to force take it but it still stopped triggering interrupts.
> 
> how about second case: kexec from RHEL 6 stock kernel to upstream kernel ?

Its impossible to distinguish between a BIOS having claimed a counter
and a previous kernel not having shut things down properly.

The best we can do is allow a force parameter and let the user keep all
pieces when he uses it.
