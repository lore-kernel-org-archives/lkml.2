Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab2HFNIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:08:10 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:43947 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2HFNII convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Mon, 6 Aug 2012 09:08:08 -0400
Message-Id: <501FDDD30200007800092DDE@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 06 Aug 2012 14:08:03 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Cc: "Ingo Molnar" <mingo@kernel.org>,
        "Matt Fleming" <matt.fleming@linux.intel.com>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cJ-ko@zougloub.eu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Regression] "x86-64/efi: Use EFI to deal with platform
 wall clock" prevents my machine from booting
References: <20120805172903.5f8bb24c@zougloub.eu>
 <501EF3A2.20200@zytor.com> <501F83F20200007800092C1C@nat28.tlf.novell.com>
 <20120806125216.GA11863@srcf.ucam.org>
In-Reply-To: <20120806125216.GA11863@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.08.12 at 14:52, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Mon, Aug 06, 2012 at 07:44:34AM +0100, Jan Beulich wrote:
> 
>> In any case, without having seen _how_ things break I don't
>> think a decision should be taken if/how to address this
>> (apparent) regression.
> 
> Machines that previously worked no longer work. That's a pretty strong 
> argument in favour of reverting until we can identify a workaround.

Yes, one can view it that way. But then again things should have
been the way they are now from the beginning - it appears
rather questionable how someone would have come up with the
strange idea to stick some #ifdef CONFIG_X86_32 in there, and
not even bother to comment this hackery. Hence my position is
that this really very likely should have never worked on the box
in question, it was merely one bug hiding another. But of course
all this is guesswork without knowing the technical details of the
observed crash.

Plus I'm pretty convinced that once the change gets reverted,
the code will remain that way for another couple of years (and
quite likely whatever UEFI implementation it is that we have
the problem with here will too), as then there's no incentive for
anyone to get this done properly (until the then very sad day
where some EFI system shows up that, being legacy free,
_really_ doesn't have a CMOS RTC anymore - with the change
at hand I merely tried to be proactive).

Jan

