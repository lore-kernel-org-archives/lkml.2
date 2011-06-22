Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1FVSJO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:09:14 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:59378 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932243Ab1FVSJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:09:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=dSE60/90YEX4Pj44Qx2lQk35FGLf3M8pY0F756NWiz5339gUvW7Tu7+EG2H8C1FBN0BYiE33VAfSa3EWZm5z2JABeTn6+0tDEXQyxBFYhop3N9DhWEXPQgaTcBjKCrtX;
Date: Wed, 22 Jun 2011 11:09:10 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Assmann <sassmann@kpanic.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, tony.luck@intel.com, andi@firstfloor.org,
        mingo@elte.hu, hpa@zytor.com, rick@vanrein.org, rdunlap@xenotime.net,
        Nancy Yuen <yuenn@google.com>, Michael Ditto <mditto@google.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
Message-Id: <20110622110910.c8e11eb7.rdunlap@xenotime.net>
In-Reply-To: <20110622110034.89ee399c.akpm@linux-foundation.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110622110034.89ee399c.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011 11:00:34 -0700 Andrew Morton wrote:

> On Wed, 22 Jun 2011 13:18:51 +0200 Stefan Assmann <sassmann@kpanic.de> wrote:
> 
> > Following the RFC for the BadRAM feature here's the updated version with
> > spelling fixes, thanks go to Randy Dunlap. Also the code is now less verbose,
> > as requested by Andi Kleen.
> > v2 with even more spelling fixes suggested by Randy.
> > Patches are against vanilla 2.6.39.
> > 
> > The idea is to allow the user to specify RAM addresses that shouldn't be
> > touched by the OS, because they are broken in some way. Not all machines have
> > hardware support for hwpoison, ECC RAM, etc, so here's a solution that allows to
> > use bitmasks to mask address patterns with the new "badram" kernel command line
> > parameter.
> > Memtest86 has an option to generate these patterns since v2.3 so the only thing
> > for the user to do should be:
> > - run Memtest86
> > - note down the pattern
> > - add badram=<pattern> to the kernel command line
> > 
> > The concerning pages are then marked with the hwpoison flag and thus won't be
> > used by the memory managment system.
> 
> The google kernel has a similar capability.  I asked Nancy to comment
> on these patches and she said:
> 
> : One, the bad addresses are passed via the kernel command line, which
> : has a limited length.  It's okay if the addresses can be fit into a
> : pattern, but that's not necessarily the case in the google kernel.  And
> : even with patterns, the limit on the command line length limits the
> : number of patterns that user can specify.  Instead we use lilo to pass
> : a file containing the bad pages in e820 format to the kernel.
> : 
> : Second, the BadRAM patch expands the address patterns from the command
> : line into individual entries in the kernel's e820 table.  The e820
> : table is a fixed buffer that supports a very small, hard coded number
> : of entries (128).  We require a much larger number of entries (on
> : the order of a few thousand), so much of the google kernel patch deals
> : with expanding the e820 table. Also, with the BadRAM patch, entries
> : that don't fit in the table are silently dropped and this isn't
> : appropriate for us.
> : 
> : Another caveat of mapping out too much bad memory in general.  If too
> : much memory is removed from low memory, a system may not boot.  We
> : solve this by generating good maps.  Our userspace tools do not map out
> : memory below a certain limit, and it verifies against a system's iomap
> : that only addresses from memory is mapped out.
> 
> I have a couple of thoughts here:
> 
> - If this patchset is merged and a major user such as google is
>   unable to use it and has to continue to carry a separate patch then
>   that's a regrettable situation for the upstream kernel.
> 
> - Google's is, afaik, the largest use case we know of: zillions of
>   machines for a number of years.  And this real-world experience tells
>   us that the badram patchset has shortcomings.  Shortcomings which we
>   can expect other users to experience.
> 
> So.  What are your thoughts on these issues?


Good comments, so where is google's patch submittal?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
