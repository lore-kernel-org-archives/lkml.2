Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2EEMLk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 08:11:40 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:50792 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915Ab2EEMLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 08:11:38 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj1SAKAXpU9V5qg+PGdsb2JhbABFijSoPxkBAQEBNzSCDAEBBAEyASMjBQsIAw44FCUKGogcCbo/E5ApYwSVfYYGg1WJUw
X-IronPort-AV: E=Sophos;i="4.75,536,1330902000"; 
   d="scan'208";a="327328335"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 5 May 2012 14:16:26 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 00/14 v3] cleanup atmel_mxt_ts
Message-ID: <20120505121626.GA754@polaris.bitmath.org>
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
 <CAGS+omDm36Sxpv_e1=W6BNx9EoeWd1H2EaPqHAaGYYWnaZjZAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGS+omDm36Sxpv_e1=W6BNx9EoeWd1H2EaPqHAaGYYWnaZjZAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Thank you to Henrik for reviewing again, and ACK'ing patch 3.

Reading it again, I do have some more comments, actually.

> Could I get a review for the rest of the set?
> There will actually be quite a few more patches that follow these.

I think that is part of the problem.  What you want to achieve is all
good, but something else is not quite right.  Reading through these
patches felt like a lot of work, although it should not really be that
much. A closer look suggests the patches are on average 20% too large,
the rest being irrelevant changes. That may look small, but apparently
it is off-putting enough. The less work it is to accept your patches,
the more likely they are to be processed quickly.

Please find brief notes below.

> > Daniel Kurtz (14):
> >  Input: atmel_mxt_ts - use CONFIG_PM_SLEEP

Seems to clash with current mainline.

> >  Input: atmel_mxt_ts - only allow root to update firmware

OK.

> >  Input: atmel_mxt_ts - refactor mxt_read/write_reg to take a length

The return value change should be split out in a separate patch,
subject to stable as well. Also, there is no real benefit in changing
the name from __mxt to mxt. It only makes the patch longer.

> >  Input: atmel_mxt_ts - verify object size in mxt_write_object

OK, also stable material.

> >  Input: atmel_mxt_ts - do not read extra (checksum) byte

OK.

> >  Input: atmel_mxt_ts - dump each message on just 1 line

OK.

> >  Input: atmel_mxt_ts - refactor mxt_object_show

Start of for loop does not need to change. The buf_end - buf is less
clear than the existing PAGE_SIZE - count.  The realloc feels clunky,
could it not allocate the max size once instead?

> >  Input: atmel_mxt_ts - optimize writing of object table entries

Seems the index variable could be kept, no real need to move the bject
deklaration around, small things like that.

> >  Input: atmel_mxt_ts - refactor get info

Why not keep mxt_get_info(), just using the smaller implementation?
Why change the formatting of the debug messages?

> >  Input: atmel_mxt_ts - simplify event reporting

Why change formatting of function, why reformat status initialization,
why new name for pressure, why change the shift functions, why change
the debug message.

> >  Input: atmel_mxt_ts - cache T9 reportid range when reading object
> >    table

Why change touchevent() function name and arguments, why not reuse the
reportid variables. Why reformat the object assignment. Aren't
T9_reportid values zero already.

> >  Input: atmel_mxt_ts - parse vector field of data packets

These could be deferred until they are actually used.

> >  Input: atmel_mxt_ts - send all MT-B slots in one input report

OK.

> >  Input: atmel_mxt_ts - parse T6 reports

Aren't T6_reportid values zero already.

Hope this helps.

Thanks.
Henrik
