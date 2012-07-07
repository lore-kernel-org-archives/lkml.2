Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab2GGBIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 21:08:32 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:50258 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab2GGBIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 21:08:30 -0400
Date: Fri, 6 Jul 2012 20:08:22 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 05/12] usb: feed USB device information to the
 /dev/random driver
Message-ID: <20120707010822.GA3097@burratino>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
 <1341614704-24965-6-git-send-email-tytso@mit.edu>
 <20120706230218.GD3728@burratino>
 <20120706232659.GA28978@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706232659.GA28978@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Theodore Ts'o wrote:
> On Fri, Jul 06, 2012 at 06:02:18PM -0500, Jonathan Nieder wrote:

>> Why cc: stable@?  Does this fix a build error, oops, hang, data
>> corruption, real security issue, or other critical "oh, that's not
>> good" bug?
>
> All of the /dev/random patches in this patch series that were marked
> for the stable backports are to address a security issue.  See:
> https://factorable.net/

Thanks for explaining.  If there's occasion for a reroll (I'm guessing
there won't be) then it would be nice to mention this in the commit
messages.

[...]
> While these patches are designed to do as much as we can without
> assuming any fixes in userspace, and the weak kea vulnerabilities are
> much more obviously detectable in embedded devices with close to zero
> available entropy, ideally there are improvements that can and should
> be done in upstream userspace packages as well as in the packaging and
> installation scripts for more general-purpose server and workstation
> distributions.
>
> For example, ssh key generation should happen as late as possible;
> ideally, some time *after* the networking has been brought up.
[...]
>               The same is true for the generation of remote
> administration keys for ntpd and bind.

Very much agreed.  These patches look like an improvement but on
diskless systems without a hardware RNG it still seems possible for
someone with knowledge of the hardware configuration to predict the
generator state.

Except that patch 2 improves matters a lot.

Thanks for your work and kindness,
Jonathan
