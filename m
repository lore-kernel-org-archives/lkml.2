Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1HDJmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 05:42:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63380 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1HDJmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 05:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110804.001314.1812549734453730417.davem@davemloft.net>
References: <20110804142858.f7f2f128e5a038beb20aa87b@canb.auug.org.au>
 <20110804163629.e866b8f3052b7ac34dc83912@canb.auug.org.au>
 <CACxGe6ss62FFwQOk49dHqEN_35iVTSz0bFg4eH1T_iSeipiJaw@mail.gmail.com> <20110804.001314.1812549734453730417.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Aug 2011 10:41:52 +0100
X-Google-Sender-Auth: xZAaFvDbz5Lx4YdC5EhEPfGubro
Message-ID: <CACxGe6u7EPGm7jrt2vCmosc+S4pg6_2afAQMJJJ=1CJ=KpDC2w@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (devicetree tree related)
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, shawn.guo@linaro.org,
        torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 8:13 AM, David Miller <davem@davemloft.net> wrote:
> In fact this points out that of_alias_scan() was only placed into one
> of the two FT unflattening sites, it needs to go into both as well as
> places that build the device tree from real OpenFirmware calls.  And
> that makes an even stronger argument for adding an allocator function
> pointer arg to this thing.

No argument from me here.  However, I completely broke sparc by
applying it so I needed to post an ASAP fix with the least possible
impact.  A followup patch for v3.2 would have be written to generalize
alias parsing for v3.2

On Thu, Aug 4, 2011 at 9:17 AM, David Miller <davem@davemloft.net> wrote:
[...]
> So even though it is implicitly creating properties, it doesn't update
> the in-kernel device tree nor does it update the OpenFirmware
> etc. copy.
>
> This behvaior is undesirable and makes no sense.  This IMX serial
> driver merely wants increasing incrementing indexes for the serial
> nodes it finds, and there are much better ways to do that.

Rolling the assigned ids into the alias list was a convenient & cheap
way of making sure the id assigned would be unique, but fair enough.
Shawn and I will talk about implementing a better solution.

[...]
> This stuff needs more work, I would like to suggest that you just
> revert at this point.

Very well, I'll prepare a revert branch and ask Linus to pull.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
