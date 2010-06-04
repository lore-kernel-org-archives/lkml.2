Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab0FDMkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:40:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36073 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab0FDMkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <20100604003607.GC24687@brick.ozlabs.ibm.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> 
	<alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> 
	<20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> 
	<20100603185333.GD25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org> 
	<1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com> <20100603194559.GF25779@flint.arm.linux.org.uk> 
	<alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org> 
	<alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org> 
	<20100604003607.GC24687@brick.ozlabs.ibm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 4 Jun 2010 06:39:40 -0600
X-Google-Sender-Auth: ludUfEHJvRZdSvrs880ODXiWLnY
Message-ID: <AANLkTilXXNQAcU9os4UuG6WMgvVuSYYPglWzaRhO6Xwx@mail.gmail.com>
Subject: Re: ARM defconfig files
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org,
       Catalin Marinas <Catalin.Marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 6:36 PM, Paul Mackerras <paulus@samba.org> wrote:
> On Thu, Jun 03, 2010 at 01:31:07PM -0700, Linus Torvalds wrote:
>
>> Now, the above is a _trivial_ one. And it's actually broken, because I
>> should not have forced CONFIG_USB (it depends on CONFIG_USB_SUPPORT).
>
> Seems to me that the brokenness of select is the main technical issue
> stopping us getting rid of the defconfigs.  If there was a way to tell
> the Kconfig machinery "I want CONFIG_USB on, you figure out what has
> to be enabled for that to make sense" then it would all work.  But
> that's a hard problem (and may possibly have multiple solutions).

Yes, I think you're right.  If select was 'smart', then the whole
issue kind of goes away.  But as you say, that is a hard problem.

In the mean time, I'd be satisfied with a solution that punted out an
error at configure time if select requirements did not get met.  I
should look at the patch Catalin posted.

g.
