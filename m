Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313Ab1EaIhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 04:37:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:58737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755256Ab1EaIhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 04:37:11 -0400
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 May 2011 09:37:03 +0100
In-Reply-To: <20110531014418.GI2890@dhcp-172-31-194-241.cam.corp.google.com>
References: <20110530072300.GA9802@elte.hu>
	 <1306745835.2029.389.camel@i7.infradead.org>
	 <20110530104231.GF17821@elte.hu> <20110530104656.GA19532@elte.hu>
	 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
	 <20110530105809.GA20133@elte.hu>
	 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
	 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
	 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
	 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
	 <20110531014418.GI2890@dhcp-172-31-194-241.cam.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306831025.2029.477.camel@i7.infradead.org>
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 21:44 -0400, Ted Ts'o wrote:
> On some architectures, I suspect there will be a dozen or more CONFIG
> that have to be a certain way in order for the machine to boot.  Are
> you really going to want to put them all on the command line?

No. This is just a convenience for setting/clearing a few options
(although "make `cat my-config-overrides` oldconfig" would also work if
you have a bunch of them, I suppose.)

Remember, we're having this discussion because Ingo needs a command-line
method to override *just* CONFIG_64BIT. Nothing more. That's all that's
really holding us back from finally completing the i386/x86_64 -> x86
merge.

> I suppose the question is whether people are using randconfig for
> simple compile testing, or just for something that they actually try
> to boot, either on real hardware or on a KVM system.  I was under the
> impression Ingo and others actually tried to boot their randconfig
> kernels, correct? 

I *sincerely* hope that isn't the reason for this requirement. If they
*are* actually booting these kernels, then they'll need more than just
one setting to be hard-coded, as you correctly observe.

That would mean that they must already be using KCONFIG_ALLCONFIG, or an
'all.config' file which overrides the settings they need for their
storage hardware, for CGROUPS to match their userspace if they have
systemd, etc.

And that, in turn, would mean that all this whining about needing an
easier way to set CONFIG_64BIT is *pure* nonsense, because they could
have just added it to their existing list.


So no, allowing CONFIG_FOO= on the make command line was not intended as
a way to set options in bulk. We have *other* ways of doing that, which
do take them from a file.

-- 
dwmw2

