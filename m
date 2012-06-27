Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab2F0PSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 11:18:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab2F0PSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 11:18:05 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=EvKSwpK77UAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=pSDxxfrZAAAA:8 a=u57L-JK2nePzAUqIh5AA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340810283.16702.19.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Wed, 27 Jun 2012 11:18:03 -0400
In-Reply-To: <1340810038.16702.16.camel@gandalf.stny.rr.com>
References: <1340651142.7037.2.camel@gandalf.stny.rr.com>
	 <20120625150722.8cd4f45d.akpm@linux-foundation.org>
	 <20120625235531.GB3652@kroah.com>
	 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
	 <20120626002307.GA4389@kroah.com>
	 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
	 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
	 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
	 <1340726856.977.6.camel@mop>
	 <1340810038.16702.16.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 11:13 -0400, Steven Rostedt wrote:

> I just tested this patch and it boots fine for me.

Of course after sending this, I rebooted to the same kernel and it
locked up :-p

Ends with:

[   47.966454] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   48.188791] kvm: disabled by bios
[   48.352547] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
[   48.410944] ALSA hda_auto_parser.c:322 autoconfig: line_outs=4 (0xd/0xf/0x10/0x11/0x0) type:line
[   48.419774] ALSA hda_auto_parser.c:326    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   48.427012] ALSA hda_auto_parser.c:330    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
[   48.433848] ALSA hda_auto_parser.c:331    mono: mono_out=0x0
[   48.439523] ALSA hda_auto_parser.c:334    dig-out=0x21/0x0
[   48.445023] ALSA hda_auto_parser.c:335    inputs:[   48.449562] ALSA hda_auto_parser.c:339  Front Mic=0xb[   48.454451] ALSA hda_auto_parser.c:339  Rear Mic=0xe[   48.459258] ALSA hda_auto_parser.c:339  Line=0xc

-- Steve

>  Better still, I put
> in my 'delay' to make sure the output shows up as it is printed, and it
> seems to do so.
> 
> Tested-by: Steven Rostedt <rostedt@goodmis.org>


