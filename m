Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab2GPDlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 23:41:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51407 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2GPDk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 23:40:59 -0400
Message-ID: <50032B11.7070505@landley.net>
Date: Sun, 15 Jul 2012 15:41:53 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
        rgetz@blackfin.uclinux.org, mpm@selenic.com
Subject: Re: feature-removal-schedule entry from 2009
References: <4FFDA698.2000707@landley.net> <20120713030325.GB12245@thunk.org>
In-Reply-To: <20120713030325.GB12245@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 10:03 PM, Theodore Ts'o wrote:
> On Wed, Jul 11, 2012 at 11:15:20AM -0500, Rob Landley wrote:
>> There are 12 remaining uses under drivers/ and 14 more under arch/, the
>> rest of the hits look like infrastructure implementing it.
>>
>> Should I run those files through bother-maintainer.pl and try to get
>> people to stop it, or is there a plan underway I don't know about?
> 
> I was going to deal with that in the new /dev/random tree; once those
> changes go in, IRQF_SAMPLE_RANDOM effectively becomes a no-op.  But
> I'd prefer that the ordering be that we get the new
> sample_interrupt_randomness() changes in first, and then remove the
> IRQF_SAMPLE_RANDOM.

Does it become a "please add a call to sample_interrupt_randomness()"
reminder, or will the infrastructure figure out when to do that outside
the driver?

And will this upcoming patch set remove 'em, or leave the NOP debris there?

> I've just been slammed with work,

I know the feeling. At my day job we work with such a "will never see
the light of day" kernel that my open source stuff is strictly
recreational, hence catching up with email on the weekend...

(How this can be license compliant: start with an obsolete version
recently _upgraded_ to 2.6.37, then the android fork off of that, then
the TI fork off of android, then our local fork off of TI. I'm sure the
hardware we eventually ship will get a technically compliant
corresponding source tarball snapshot sans repository history posted
_somewhere_, but nobody will ever care.)

> processing patches for the ext4
> merge window, and kernel summit planning, and quite frankly, I
> considered this to be relatively low priority --- especially since we
> no shortage of IRQF_* flag bits, and once the new
> sample_interrupt_randomness() goes in, the flag is a complete no-op.

Sure, I'm just bussing tables and asking "you done with that". I only
poke 'cuz it's been 3 years.

> 			      	       	   	- Ted

Rob
-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
