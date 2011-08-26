Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1HZGWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 02:22:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39986 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab1HZGWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 02:22:30 -0400
Date: Fri, 26 Aug 2011 10:22:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ralf Jung <ralfjung-e@gmx.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, ioapic: Reserve only 128 bytes for IOAPICs
Message-ID: <20110826062224.GA3903@sun>
References: <20110825230539.5355.13851.stgit@bhelgaas.mtv.corp.google.com>
 <1314315225.16133.30.camel@sbsiddha-desk.sc.intel.com>
 <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAErSpo7N3UBJgQTb+zePnsf5YuFSQT8zy9CftwceyAKKfcHUjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 06:17:06PM -0600, Bjorn Helgaas wrote:
> On Thu, Aug 25, 2011 at 5:33 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > On Thu, 2011-08-25 at 16:05 -0700, Bjorn Helgaas wrote:
> >> Previously we reserved 1024 bytes, but that's more space than the IOAPIC
> >> consumes, and it can cause conflicts with nearby devices.  The known
> >> requirement is 68 bytes (sizeof(struct io_apic)), and rounding up to a
> >> power-of-2 gives us 128.
> >>
> >
> > Bjorn, Given the info from Intel that most of its io-apic
> > implementations has registers up to 0xff offset (reserved), does
> > reserving just the 128 bytes for the io-apic cause any address conflicts
> > if the next 128 bytes are allocated (by the OS) for any other device.
> 
> If the OS allocated the next 128 bytes to another device, it sounds
> like it would cause a conflict on Intel boxes.  This must be an area
> that differs between vendors.  I haven't seen a spec that mentions 256
> bytes as the required minimum MMIO size for IOAPICs, and apparently
> the AMD IOAPIC decodes 240 bytes or fewer.
> 

Hi Bjorn,

the former idea (as far as I remember) of all this IO_APIC_SLOT_SIZE
was to be sure the io-apics are allocated with 1K step (which
is requirements for io-apics), but definitely it doesn't consume
that much space neither it decode the whole range.

Which means, I would prefer if we have (since we change IO_APIC_SLOT_SIZE
anyway) some additional check and WARN_ON in this code. Something like

 if (io-apic-base-address & 0x3ff)
   WARN_ON();

Hm? (also we have bad_ioapic() check, probably should put such test
there instead).

	Cyrill
