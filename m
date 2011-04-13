Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab1DMOzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:55:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756897Ab1DMOzk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:55:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110413043246.24974.qmail@science.horizon.com>
References: <20110413043246.24974.qmail@science.horizon.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Apr 2011 07:54:50 -0700
Message-ID: <BANLkTi=owU+pg299PPNryhL2DbEpBTDEoQ@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
To: George Spelvin <linux@horizon.com>
Cc: davej@redhat.com, linux-kernel@vger.kernel.org, joro@8bytes.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 9:32 PM, George Spelvin <linux@horizon.com> wrote:
>
> Note that the discussion on the libmount mailing list revealed a possible
> kernel workaround: escape the hyphens as \055.  Damn hard to read for
> a human, but it does parse correctly, and the workaround can be fixed
> once the library updates have propagated.

I'd rather replace it with some non-dash character that is
human-readable, like '+' or some utf-8 sequence that _looks_ like a
dash.

So it wouldn't parse as a uuid to some code - big deal. Clearly
neither does the correct dash. Using \055 would be just ugly.

Of course, not exposing it at all is also a reasonable strategy.

Who uses /proc/self/mountinfo? I see the problem on my alpha Fedora-15
test-machine, but Fedora-14 doesn't seem to do it. Ubuntu? SuSE? Do we
know how widespread the breakage is?

If it is _just_ Fedora-15, then I presume that pushing out the
util-linux fix and waiting a few weeks will fix it (since anybody
using F-15 right now lives on the edge anyway, and a real release
hasn't happened). But if we have real releases using it, then we may
need to look at workarounds using non-'-' characters if people really
want the uuid showing up any time soon.

                      Linus
