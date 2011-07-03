Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab1GCS5S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 14:57:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41674 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab1GCS5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 14:57:15 -0400
Date: Sun, 3 Jul 2011 22:57:09 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC v1] implement SL*B and stack usercopy runtime checks
Message-ID: <20110703185709.GA7414@albatros>
References: <20110703111028.GA2862@albatros>
 <CA+55aFzXEoTyK0Sm-y=6xGmLMWzQiSQ7ELJ2-WL_PrP3r44MSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzXEoTyK0Sm-y=6xGmLMWzQiSQ7ELJ2-WL_PrP3r44MSg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 11:27 -0700, Linus Torvalds wrote:
> That patch is entirely insane. No way in hell will that ever get merged.

Sure, this is just an RFC :)  I didn't think about proposing it as a
patch as is, I tried to just show how/what checks it introduces.


> copy_to/from_user() is some of the most performance-critical code, and
> runs a *lot*, often for fairly small structures (ie 'fstat()' etc).
> 
> Adding random ad-hoc tests to it is entirely inappropriate. Doing so
> unconditionally is insane.

That's why I've asked whether it makes sense to guard it with
CONFIG_XXX, defaults to =n.  Some distributions might think it makes
sense to enable it sacrificing some speed.

Will do.


> If you seriously clean it up (that at a minimum includes things like
> making it configurable using some pretty helper function that just
> compiles away for all the normal cases,

Hm, it is not as simple as it looks at the first glance - even if the
object size is known at the compile time (__compiletime_object_size), it
might be a field of a structure, which crosses the slab object
boundaries because of an overflow.

However, if interpret constants fed to copy_*_user() as equivalent to
{get,put}_user() (== worry about size argument overflow only), then it
might be useful here.


>    if (!slab_access_ok(to, n) || !stack_access_ok(to, n))

OK :)


Thanks!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
