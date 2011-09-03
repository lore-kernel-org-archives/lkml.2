Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1ICJcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 05:32:51 -0400
Received: from gw1.transmode.se ([195.58.98.146]:56091 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1ICJct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 05:32:49 -0400
In-Reply-To: <20110902165020.7c6b5382.akpm@linux-foundation.org>
References: <4E5EB5CC.1010605@systemfabricworks.com> <20110902165020.7c6b5382.akpm@linux-foundation.org>
Subject: Re: [PATCH v6 00/10] crc32
X-KeepSent: F9DA484B:B301BBA9-C1257900:0033D34C;
 type=4; name=$KeepSent
To: Andrew Morton <akpm@linux-foundation.org>
Cc: fzago@systemfabricworks.com, George Spelvin <linux@horizon.com>,
        linux-kernel@vger.kernel.org,
        Bob Pearson <rpearson@systemfabricworks.com>
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFF9DA484B.B301BBA9-ONC1257900.0033D34C-C1257900.00346FEF@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Sat, 3 Sep 2011 11:32:45 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 09/03/2011 11:32:45
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton <akpm@linux-foundation.org> wrote on 2011/09/03 01:50:20:
>
> On Wed, 31 Aug 2011 17:29:32 -0500
> Bob Pearson <rpearson@systemfabricworks.com> wrote:
>
> > This is an attempt to resolve all the issues that were left in the last review.
> > There is one proposed change that is still causing a difference of opinion
> > which has to do with the form of the loops and their performance on x86 and ppc
> > This version has the change to the form that runs faster on x86 as an ifdef.
> >
> > This patch series provides improved performance for computing the crc32
> > polynomial on common hardware by adding the Slicing-by-8 algorithm to the
> > existing algorithms already included. The new algorithm is very closely
> > related to the existing algorithm so the extension requires small changes
> > to implement.  Additionally it cleans up some warnings in the existing
> > code and adds a kernel mode optional self test to replace the existing
> > user mode self test.
> >
> > A description of the existing and new algorithm is included in
> > Documentation/crc32.txt.
>
> So...  are the crc wars over yet?  I hope it's safe to look at the
> patches now ;)

Hehe, not sure :) I got side tracked with other things and haven't had time
to look into this last series.

>
> Please see Documentation/SubmittingPatches Section 15's discussion of
> patch Subject: lines.
>
> Is there any code in the kernel which uses the crc code so much that we
> actually care about its performance?

Sure, JFFS2/UBIFS/LogFS uses it heavily. SCTP too although it uses CRC32c, the
SW impl. of CRC32c should be moved to the same place as crc32.c

 Jocke

