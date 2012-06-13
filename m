Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2FMPh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:37:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:35049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2FMPh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:37:58 -0400
Message-ID: <1339601872.8980.52.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
Date: Wed, 13 Jun 2012 17:37:52 +0200
In-Reply-To: <4FD89D09.6010800@zytor.com>
References: <20120607071531.GA4849@quad> <4FD78BE6.4060207@zytor.com>
	  <20120612190720.GA11137@aftab.osrc.amd.com>
	  <1339529614.31548.104.camel@twins>
	  <20120612194900.GC11137@aftab.osrc.amd.com> <4FD7A687.3040500@zytor.com>
	  <20120612203730.GE11137@aftab.osrc.amd.com> <4FD7A99F.8030007@zytor.com>
	  <20120612205609.GF11137@aftab.osrc.amd.com> <4FD7AD6F.6010008@zytor.com>
	 <1339576681.31548.116.camel@twins> <4FD89D09.6010800@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 07:00 -0700, H. Peter Anvin wrote:
> On 06/13/2012 01:38 AM, Peter Zijlstra wrote:
> > On Tue, 2012-06-12 at 13:58 -0700, H. Peter Anvin wrote:
> >>  even things like Nehalem + Westmere in the same system
> > 
> > Uhm,.. how well do you expect Linux to run on a franken-system like
> > that? I'm pretty sure perf will malfunction in such a setup.
> > 
> 
> perf might, but I have seen such frankensystems in the field and they
> work (although I haven't seen that particular combo, I have to admit.)

Thing is, if we boot on the wsm, perf could fault the system with
nonexistent MSR accesses, if we boot on the nhm worst is wrong numbers I
think.

I'm not really inclined to 'fix' this.. the best I'm willing to accept
is a patch that would detect this situation and simply disable all
hardware perf support for the platform.
