Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933972Ab2C2VPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 17:15:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44641 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933934Ab2C2VPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 17:15:05 -0400
MIME-Version: 1.0
In-Reply-To: <1333008684.3010.9.camel@pasglop>
References: <5599.1332958811@redhat.com> <30702.1332989444@neuling.org>
 <20120329135555.06593144b65bf81cc9191f8a@canb.auug.org.au>
 <20120329151544.ef2117821dfb459e8b52af48@canb.auug.org.au>
 <CA+55aFzn=bsH76hPDUgS-FBP=RVu51gwmRdqjkw5RJO=Q_cRfA@mail.gmail.com>
 <20120329154238.1ce219f7c998da45452af4b2@canb.auug.org.au>
 <CA+55aFzjQ7qb=bPAj_gGoGLPXOGweTaqtmOBZH4mUt8E_KQwsg@mail.gmail.com> <1333008684.3010.9.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 29 Mar 2012 15:14:42 -0600
X-Google-Sender-Auth: dC0FB3gzPRll2vlIixvziIzfaUI
Message-ID: <CACxGe6v+nMMuEM+bBMdYf_OeuaXb+NsS0qz-+puRtdzHLPH2hA@mail.gmail.com>
Subject: Re: [GIT PULL] Disintegrate and kill asm/system.h
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-arch@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        paul.gortmaker@windriver.com, hpa@zytor.com, akpm@linux-foundation.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 2:11 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2012-03-28 at 22:02 -0700, Linus Torvalds wrote:
>> On Wed, Mar 28, 2012 at 9:42 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> > How about this (build tested on powerpc allyesconfig):
>>
>> Looks better.
>>
>> Grant - what's the plan about that CONFIG_VIRQ_DEBUG thing? In theory
>> something like it could be useful as a generic thing, but at least
>> right now it is clearly powerpc-specific (not just that the config
>> option only exists for powerpc: it has that whole
>> 'powerpc_debugfs_root' thing in it)?
>>
>> Stephen's patch very much looks like the right thing, but if there was
>> some plan to actually make this generic ...
>
> Yes, as I said earlier I think Grant should make it generic, there's
> no reason to keep that powerpc specific, it's fairly useful and nothing
> in userspace relies on the existing location of the debugfs file that I
> know about.
>
> Another option is to put the mapping information in /proc/interrupts but
> worry that changing anything in there (like adding a column) will break
> countless userspace tools.

I posted an RFC patch that does exactly that, but I'm similarly
nervous for the same reason:

http://www.mail-archive.com/linuxppc-dev@lists.ozlabs.org/msg56368.html

The rightmost fields of /proc/interrupts are a weird set of
conditional outputs that don't really have any parsable formatting to
them.  It may be safe to apply my patch because it adds another field
in the middle of a section of conditional outputs* anyway so tools
already won't know what those fields mean.  But, regardless, I'm not
going to take responsibility for applying that patch unless encouraged
by several other maintainers to do so.

*It's added to the middle instead of the end purely for aesthetic
reasons.  The rightmost field is a freeform string without a field
width, so if put at the end they would never line up.  Suggestions for
a better layout are welcome.

g.
