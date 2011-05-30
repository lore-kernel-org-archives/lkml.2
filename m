Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab1E3T4D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:56:03 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:48654 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755734Ab1E3T4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:56:01 -0400
Date: Mon, 30 May 2011 15:55:45 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530195545.GG2890@dhcp-172-31-194-241.cam.corp.google.com>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1306707270.2029.377.camel@i7.infradead.org>
 <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530104231.GF17821@elte.hu>
 <20110530104656.GA19532@elte.hu>
 <E934876C-FABB-41F8-8C5E-469AA42DBE91@mit.edu>
 <20110530105809.GA20133@elte.hu>
 <1A4DB87D-9B32-44C0-B7C9-47A003CABD96@mit.edu>
 <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105301955210.3164@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 08:03:08PM +0100, David Woodhouse wrote:
> 
> And that the legacy trick of using ARCH=i386 or ARCH=x86_64 as a hack to 
> override *just* CONFOG_64BIT, although nobody has posted a patch which 
> removes or breaks that, probably ought to be deprecated in favour of a 
> more generic way to override config options - one that doesn't work only 
> for *one* config option, and only on *one* architecture.

So I could imagine two ways of doing this.  One would be a new file,
.config-fixed, that contains a series of "CONFIG_XXX=[ymn]" which
would have to be satisfied and which override what
allyesconfig/allnoconfig/randconfig would otherwise do.

The other way would be some kind of new tagging in the .config file
itself, e.g.:

CONFIG_64BIT=y	# FIXED


There are all sorts of interesting design questions hidden in here, of
course, including what if the fixedpoint declarations (whether done
via a separate file or via tags in .config) are mutually inconsistent.

      	       	       	   	   	    - Ted
