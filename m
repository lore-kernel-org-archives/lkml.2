Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab1EaBoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 21:44:32 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:51634 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662Ab1EaBob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 21:44:31 -0400
Date: Mon, 30 May 2011 21:44:18 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110531014418.GI2890@dhcp-172-31-194-241.cam.corp.google.com>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
 <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
 <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105302103220.3164@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 09:12:17PM +0100, David Woodhouse wrote:
> 
> Which is apparently what KCONFIG_ALLCONFIG already does? It doesn't work 
> for choices, but it's still fine for setting/clearing CONFIG_64BIT.
>  
> We'll want to make it simpler to use - so you really can do something like
>    make CONFIG_64BIT=n randconfig
>    make CONFIG_64BIT=n allmodconfig
>    make CONFIG_64BIT=y CONFIG_SATA_MV=y oldconfig
> etc. without having to create a text file. But that's not hard. A simple 
> implementation might just *make* a file with the options on the command 
> line and point KCONFIG_ALLCONFIG at it to start with, although there are 
> probably cleaner ways to implement it.

On some architectures, I suspect there will be a dozen or more CONFIG
that have to be a certain way in order for the machine to boot.  Are
you really going to want to put them all on the command line?

I suppose the question is whether people are using randconfig for
simple compile testing, or just for something that they actually try
to boot, either on real hardware or on a KVM system.  I was under the
impression Ingo and others actually tried to boot their randconfig
kernels, correct?

    	   	    	    	     	 - Ted
