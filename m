Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716Ab1FWQ12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:27:28 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54064 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1FWQ11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:27:27 -0400
From: "Grosen, Mark" <mgrosen@ti.com>
To: Michael Williamson <michael.williamson@criticallink.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
CC: davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>, Brian Swetland <swetland@google.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC 0/8] Introducing a generic AMP/IPC framework
Thread-Topic: [RFC 0/8] Introducing a generic AMP/IPC framework
Thread-Index: AQHML+QkyBZcsabgrUapQCsRzbK3+pTLNMCA///qS/A=
Date: Thu, 23 Jun 2011 16:27:10 +0000
Message-ID: <FFF198FBBF957F4393BA834040FEFFA202CA6E@DFLE35.ent.ti.com>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com>
 <4E033041.9090606@criticallink.com>
In-Reply-To: <4E033041.9090606@criticallink.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Michael Williamson
> Sent: Thursday, June 23, 2011 5:23 AM
...
> I'd like to kick the tires on this with a da850 based platform (MityDSP-L138).
> Any chance you might be able to share the stuff you did on the remote side
> (DSP/BIOS adaptations for rpmsg,  utils for ELF or COFF conversion to
> firmware format, etc.) for the DSP side of your tests done with the
> hawkboard?

We have only implemented the remoteproc (load, start, stop) part for
OMAPL138 so far, i.e., not the rpmsg part (communications). I am not sure
when we will get to the rpmsg part.

We will be publishing a Git tree soon with the "remote processor" code under
a BSD license. This code works with our TI RTOS, SYS/BIOS (also BSD), on
both M3 and DSP CPUs. This will include the utility to generate the RPRC
firmware format from an ELF file. Note that the Linux side does not have any
explicit binding or dependency on the runtime environment on the remote
processor, so alternate RTOS or bare-metal implementations could also be
done. We will post a follow-up to the list with a URL soon.

> It looks like, at least for the da850, this subsumes or obsoletes
> DSPLINK in order to drive a more general purpose architecture
> (which looks great, so far, BTW).
> Is that the intent?

First, we are not abandoning DSPLINK. We have many users of this, even
though it is out-of-tree, and we will continue to support it. That said, we
do intend to make this new design the basis for DSPLINK-like
functionality. It's designed to be done "the right way" for Linux (and we
are looking for feedback to make it better).  It is also designed to be more
scalable and extensible in userspace. With a solid kernel foundation, we can
provide lots of functionality in userspace, or users can implement their own
custom solutions. One of the key things to do is map our existing DSPLINK
APIs, like MessageQ, to the new rpmsg transport.

Mark
