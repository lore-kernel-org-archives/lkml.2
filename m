Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311Ab1KVUcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:32:47 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51220 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757672Ab1KVUcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:32:46 -0500
MIME-Version: 1.0
In-Reply-To: <3badc590e12be93a2d2ffbf998d138a81e6e7181.1321917278.git.david.decotigny@google.com>
References: <cover.1321917278.git.david.decotigny@google.com>
	<3badc590e12be93a2d2ffbf998d138a81e6e7181.1321917278.git.david.decotigny@google.com>
Date: Tue, 22 Nov 2011 12:32:45 -0800
Message-ID: <CAHo-OozdBn5jBNsRVzbCnmxozquJnTAYa0bNbK5VoaiKaK=7qQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 3/4] net-e1000e: reworked carrier detection logic
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: David Decotigny <david.decotigny@google.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I know you asked for a review of this on Friday, before you sent this
out to netdev, and I was planning on doing so, but I see you've sent
it out to a wider audience now.
So, I'll attach comments directly here.

You took my patch (which was for 2.6.34) and split it in two (it was
erroneously marked author zenczykowski@gmail.com instead of
maze@google.com, so that should be fixed) and while you seem to have
reduced the amount of lines-of-code-churn, I'm not sure you've
actually made the resulting code (as a whole) more readable.

I'm not sure how much of these changes were a result of changes
elsewhere in the driver between 2.6.34 and now.

This was very tricky code to get right, and I'm not sure whether the
patch as you posted it gets all the corner cases right...
Indeed I actually think the changes you've made reduce the robustness
wrt. timeouts caused by firmware concurrent accesses.  In particular
the first read access you make is very likely to fail.
I think renaming success to link and iterations to intervals was
worthwhile since it improved readability...

For reference, the original patch, cherrypicked onto net-next and
compile (but not anything else) tested will be a reply to this email.
