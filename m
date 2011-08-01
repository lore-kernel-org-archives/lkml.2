Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1HABkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 21:40:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab1HABkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 21:40:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110801012813.GR5404@dastard>
References: <20110728164105.GA18258@infradead.org> <20110729142121.GA21149@localhost>
 <20110730134422.GA1884@infradead.org> <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard> <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 31 Jul 2011 15:40:20 -1000
Message-ID: <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
Subject: Re: xfstests 073 regression
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 31, 2011 at 3:28 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> IOWs, what I'm asking is whether this "just move the inodes one at a
> time to a different queue" is just a bandaid for a particular
> symptom of a deeper problem we haven't realised existed....

Deeper problems in writeback? Unpossible.

The writeback code has pretty much always been just a collection of
"bandaids for particular symptoms of deeper problems".  So let's just
say I'd not be shocked. But what else would you suggest? You could
just break out of the loop if you can't get the read lock, but while
the *common* case is likely that a lot of the inodes are on the same
filesystem, that's certainly not the only possible case.

                 Linus
