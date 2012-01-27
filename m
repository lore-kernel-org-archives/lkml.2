Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2A0AXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:23:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36024 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2A0AXH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:23:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120127000612.GA14678@suse.de>
References: <20120123180601.GA24553@phenom.dumpdata.com> <20120127000612.GA14678@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 27 Jan 2012 01:22:46 +0100
Message-ID: <CAPXgP134gz6baAiVPPfhdaQsYZ5hDncZfb4C_Wj=iC51=Uqixw@mail.gmail.com>
Subject: Re: WARN... Device 'cpu1' does not have a release() function, it is
 broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
To: Greg KH <gregkh@suse.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, bp@amd64.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, lenb@kernel.org,
        xen-devel@lists.xensource.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 01:06, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jan 23, 2012 at 01:06:01PM -0500, Konrad Rzeszutek Wilk wrote:

>> Is anybody else hitting this with ACPI CPU hot-unplug? Or do I have
>> the privilige of being the first? Oh, I hadn't done a full bisection
>> but v3.2 does not have this.
>
> Kay, this is a mess.
>
> This cpu system device is is interconnected with the different arches
> and their cpu-specific structures.  Some arches have a static array,
> some allocate a huge structure (struct arch_cpu * NUM_CPUS), and others
> try to do the right thing with DECLARE_PER_CPU() but don't quite get it
> right, making that a static array per cpu.
>
> To unwind all of this, is much beyond 3.3 material, as I'm sure I'll get
> it wrong, and have a bunch of non-x86-64 build problems along the way.
>
> Any objection to me just doing the "hack" of the empty release function
> at the moment to get rid of this warning, and then clean it all up
> properly for 3.4?

No problem at all.

It would be nice if we get all that to the usual model some day, but I
can totally see that CPU devices try to deal with statically allocated
per-cpu memory. It seems fine, as long as they know what they are
doing.

Just silencing the driver-core warning here sounds fine to me.

Thanks,
Kay
