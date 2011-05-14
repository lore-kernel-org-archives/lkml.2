Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab1ENGCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 02:02:32 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64158 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab1ENGCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 02:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C5I/SAoXSl/4fEceHKd6ylUDucRUCBEkeEuICJRyfPzrvvyCDN6jrWaWDGyrvat2dN
         iC53lDZqa/qag/B+AbgwzG1EZrOOkeYADP45UItMNgYFJpSekCocT7bsGlhyMEVbiUCm
         elkYjvrWF1wI8moPDjO2pHxsPsOhMRSy9f78s=
MIME-Version: 1.0
In-Reply-To: <20110514051303.GE14607@jayachandranc.netlogicmicro.com>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
	<20110513150707.GA26389@linux-mips.org>
	<BANLkTikcyEzjOWt9pWToE=89dySSEYbw_g@mail.gmail.com>
	<20110513155605.GA30674@linux-mips.org>
	<BANLkTinnALQV6dXkJ0AjaQ1=bTawYMMkuQ@mail.gmail.com>
	<20110513173633.GA14607@jayachandranc.netlogicmicro.com>
	<BANLkTim+z7TSCvNA2duA6LsUzNsiu9OQaQ@mail.gmail.com>
	<20110513184532.GC14607@jayachandranc.netlogicmicro.com>
	<BANLkTi=CJPuhO7OjCv5UF_ABQMb-bFe-2A@mail.gmail.com>
	<20110514051303.GE14607@jayachandranc.netlogicmicro.com>
Date: Fri, 13 May 2011 23:02:27 -0700
Message-ID: <BANLkTimuz8bgrpwJTSh4guDXt+h2hUvSGQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
From: Kevin Cernekee <cernekee@gmail.com>
To: "Jayachandran C." <jayachandranc@netlogicmicro.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 10:13 PM, Jayachandran C.
<jayachandranc@netlogicmicro.com> wrote:
> Can you send me the patchset which works on top of queue with any
> debugging you want enabled?  I can try that and send you the results.
>
> It is also possible that something is broken with the XLR platform code,
> it is currently almost straight r4k...

Well, David suggested adding "#define DEBUG 1" at the very top of
tlbex.c, then booting with "debug" and posting the TLB refill handler
to make sure the RI/XI code isn't getting enabled.  That seems like a
reasonable start.  Even if there's no smoking gun, we'd still be able
to compare our TLB handlers side-by-side.

Personally I don't have any other leads or patches to try.  These
changes work fine for me in every configuration I am able to test:

32-bit MIPS32 system, 32-bit kernel (non-RIXI)
32-bit MIPS32 system, 32-bit kernel (XI)
64-bit R5000 system, 32-bit kernel (non-RIXI, with 64-bit physical addresses)
64-bit R5000 system, 64-bit kernel (non-RIXI)

So it's really best for somebody to debug the problem hands-on, on the
system that showed the issue.

Would you be able to post your rootfs image?  Are you using
"usr/dev_file_list usr/rootfs" from CONFIG_INITRAMFS_SOURCE?  That
could eliminate one other potential difference between our
configurations.
