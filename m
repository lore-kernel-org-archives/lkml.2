Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2GRVp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 17:45:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42063 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2GRVp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 17:45:26 -0400
Date: Wed, 18 Jul 2012 23:45:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120718214520.GA14067@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
	Steve Hodgson <steve@purestorage.com>
References: <20120424205946.GH20610@logfs.org>
 <x49zka0j5bk.fsf@segfault.boston.devel.redhat.com>
 <20120425132513.GA23492@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <20120713130336.GC10298@x1.osrc.amd.com>
 <20120713162009.GA10268@logfs.org>
 <20120716124614.GA19497@x1.osrc.amd.com>
 <20120718185335.GA1771@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120718185335.GA1771@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 02:53:35PM -0400, Jörn Engel wrote:

[ … ]

> > $ ./mkblockconsole /dev/sdc
> > 
> > <reboot>
> 
> You can also run hdparm -z <dev> instead.  Or replug the device.  Main
> danger of hdparm is that running the command twice will cause two
> instances of blockconsole to use the same device.  Not sure how to
> solve that problem - or if.

Actually, I meant <reboot> in the sense here that I wanted to test the
case where user has a prepared stick and wants to catch full boot log of
the booting system.

> > So why is that first megabyte full of zeros there?
> 
> It gives you some scratch space to store information in.

How? By me writing something in that empty line in vim? Or something
else storing stuff there?

> How useful that actually is may be a matter of opinion. But
> independent of that, you will find large amounts of zeroes all over.
> Every time you reboot, the new blockconsole will start writing at a
> megabyte-aligned offset and whatever remains of the last megabyte
> should be zero-filled as well.

Ah, those are the tiles you're talking about in the docs, right?

> Vim treats this as a single line, which makes it only mildly annoying
> to me.

Ok, I should try that.

> > Other than that, it works like a charm and I like the idea that no
> > kernel cmdline args are needed.
> > 
> > Also, you might want to add a step-by-step fast howto to the docs with
> > concrete steps like the above so that people can try this out faster.
> 
> I will try to find a quiet moment for that.  If you happened to beat
> me to it, you certainly won't hear any complaints.

Oh, I didn't mean anything involved but rather a quick steps write-up
(steps can always be expanded and made more verbose later):

Blocksonsole in three easy steps
================================

1. Find an unused USB stick and prepare it for blockconsole by writing
the blockconsole signature to it:

$ ./mkblockconsole /dev/sdc

  [ Assuming /dev/sdc is the device node of the USB stick you just mounted. ]

2. USB stick is ready for use, replug it so that the kernel can start
logging to it.

3. After you've done logging, read out the logs from it like this:

$ ./bcon_tail

  [ This creates a file called /var/log/bcon.<random number> which
  contains the logs. Open it with a sane editor like vim which can
  display zeroed gaps as a single line and start staring at the logs. ]

---

Something like the above, just slap it at the beginning of
Documentation/block/blockconsole.txt for impatient people like me and
that's it :-).

Thanks.

-- 
Regards/Gruss,
    Boris.
