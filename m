Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab0KFOKs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:10:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49925 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab0KFOKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kq0Cmsy5h7ChZJRu1Dx4t01HZrqLwER10D2gG/KriZOGLgcokkSx4Bq6SYI186TQUd
         A1eQtESLsFmcgfwzfCuoi1votcxftxxWv8L9nCFO8zxa3I+zcPNVB/h3V6ql25IsNo2W
         zFM8S6gomI1kaLRwpA6GVAcJeQDM5FkFU61gk=
MIME-Version: 1.0
In-Reply-To: <E1PELiI-0001Pj-8g@approx.mit.edu>
References: <20101105014334.GF13830@dastard> <E1PELiI-0001Pj-8g@approx.mit.edu>
From: dave b <db.pub.mail@gmail.com>
Date: Sun, 7 Nov 2010 01:10:24 +1100
Message-ID: <AANLkTimON_GL6vRF9=_U6oRFQ30EYssx3wv5xdNsU9JM@mail.gmail.com>
Subject: Re: 2.6.36 io bring the system to its knees
To: Sanjoy Mahajan <sanjoy@olin.edu>
Cc: Dave Chinner <david@fromorbit.com>, Jesper Juhl <jj@chaosbits.net>,
        Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>,
        Aidar Kultayev <the.aidar@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, "Ted Ts'o" <tytso@mit.edu>,
        Corrado Zoccolo <czoccolo@gmail.com>,
        Shaohua Li <shaohua.li@intel.com>, Steven Barrett <damentz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I now personally have thought that this problem is the kernel not
keeping track of reads vs writers properly  or not providing enough
time to reading processes as writing ones which look like they are
blocking the system....

If you want to do a simple test do an unlimited dd  (or two dd's of a
limited size, say 10gb) and a find /
Tell me how it goes :) ( the system will stall)
(obviously stop the dd after some time :) ).

http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/4561
iirc can reproduce this on plain ext3.
