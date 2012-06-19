Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab2FSSav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:30:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42755 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753158Ab2FSSau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:30:50 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2012 14:30:50 EDT
X-Sasl-enc: HBNg2qzR9wF4E16zWBw2bdupfAmfKdXwh8szgweLxN7G 1340130151
Date: Tue, 19 Jun 2012 15:22:29 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] x86, microcode: Make reload interface per system
Message-ID: <20120619182228.GA18816@khazad-dum.debian.net>
References: <20120615123749.GC6083@aftab.osrc.amd.com>
 <1339764161.2559.63.camel@twins>
 <20120615125240.GD6083@aftab.osrc.amd.com>
 <20120615165231.GA9169@aftab.osrc.amd.com>
 <20120619024639.GB6186@khazad-dum.debian.net>
 <4FDFF27C.5000205@zytor.com>
 <20120619051116.GB31591@aftab.osrc.amd.com>
 <1340093864.21745.6.camel@twins>
 <20120619102250.GA787@aftab.osrc.amd.com>
 <1340101568.21745.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340101568.21745.37.camel@twins>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Peter Zijlstra wrote:
> On Tue, 2012-06-19 at 12:22 +0200, Borislav Petkov wrote:
> > But I haven't tested what happens when it is built in and I use the
> > reload interface, hehe something to play with today. 
> 
> I couldn't easily find where to place the damn ucode image anyway, so I
> built in the old-style /dev interface and used the microcode.ctl package
> to load it.

The firmware interface is fine *after the system boot*, we just needed a
better way to trigger it through sysfs.  These patches address that.

The sysfs interface is useful to immediately apply a microcode update
when a new one is made available, without the need for a reboot... most
microcode updates are not of the sort the kernel is testing for their
presence at boot.   The sysfs interface is also useful when the required
microcode is not available at the time the microcode driver first
requests it.

We still need a proper way to load microcode very very early (which
requires that the microcode be available to the kernel  and THAT
has nothing to do with sysfs :-)

Even if we have the very early microcode facility, we *still* want the
runtime one based on sysfs+request_firmware in order to update microcode
without the need for a reboot.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
