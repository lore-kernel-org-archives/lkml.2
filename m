Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2JIVUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 17:20:18 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:50012 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600Ab2JIVUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 17:20:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgQfANyTdFB5LIL3/2dsb2JhbABFhhGzNIRjBIEEgQmCIAEBBAEjDwEjIwULCAECFQMCAiMDAgIUJQMKFxMUh2sFDKc9kn8EFIENiiI7hEaBEgOVapAxgwGBSCM
Date: Wed, 10 Oct 2012 08:20:12 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: "=?utf-8?B?J0x1a8OhxaE=?= Czerner'" <lczerner@redhat.com>,
        "'Namjae Jeon'" <linkinjeon@gmail.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Marco Stornelli'" <marco.stornelli@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
Message-ID: <20121009212012.GO23644@dastard>
References: <50712AAA.5030807@gmail.com>
 <002201cda46e$88b84d30$9a28e790$%kim@samsung.com>
 <F7EA5AF7-8A1C-4C98-90AF-9D47E39731AB@dubeyko.com>
 <004101cda52e$72210e20$56632a60$%kim@samsung.com>
 <CAKYAXd_Y0Y0kLyqEm1FVO5TpvrN-WwnF40H3hMe5B7_cTe0nMw@mail.gmail.com>
 <004a01cda542$f398e2c0$dacaa840$%kim@samsung.com>
 <alpine.LFD.2.00.1210091020390.11244@dhcp-1-104.brq.redhat.com>
 <007c01cda60b$43e7fae0$cbb7f0a0$%kim@samsung.com>
 <alpine.LFD.2.00.1210091250590.11244@dhcp-1-104.brq.redhat.com>
 <008301cda615$ca3b9980$5eb2cc80$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <008301cda615$ca3b9980$5eb2cc80$%kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Folks, can you trim your responses down to just quote the part you
are responding to? Having to repeatedly scroll through 500 lines of
irrelevant text just to find the 5 lines that is being commented on
is exceedingly painful.  ]

On Tue, Oct 09, 2012 at 09:01:18PM +0900, Jaegeuk Kim wrote:
> > From: Lukáš Czerner [mailto:lczerner@redhat.com]
> > > > I am sorry but this reply makes me smile. How can you design a fs
> > > > relying on time attack heuristics to figure out what the proper
> > > > layout should be ? Or even endorse such heuristics to be used in
> > > > mkfs ? What we should be focusing on is to push vendors to actually
> > > > give us such information so we can properly propagate that
> > > > throughout the kernel - that's something everyone will benefit from.
> > > > After that the optimization can be done in every file system.
> > > >
> > >
> > > Frankly speaking, I agree that it would be the right direction eventually.
> > > But, as you know, it's very difficult for all flash vendors to promote and standardize that.
> > > Because each vendors have different strategies to open their internal information and also try
> > > to protect their secrets whatever they are.
> > >
> > > IMO, we don't need to wait them now.
> > > Instead, from the start, I suggest f2fs that uses those information to the file system design.
> > > In addition, I suggest using heuristics right now as best efforts.

And in response, other people are "suggesting" that this is the
wrong approach.

> > > Maybe in future, if vendors give something, f2fs would be more feasible.
> > > In the mean time, I strongly hope to validate and stabilize f2fs with community.
> > 
> > Do not get me wrong, I do not think it is worth to wait for vendors
> > to come to their senses, but it is worth constantly reminding that
> > we *need* this kind of information and those heuristics are not
> > feasible in the long run anyway.
> > 
> > I believe that this conversation happened several times already, but
> > what about having independent public database of all the internal
> > information about hw from different vendors where users can add
> > information gathered by the time attack heuristic so other does not
> > have to run this again and again. I am not sure if Linaro or someone
> > else have something like that, someone can maybe post a link to that.

Linaro already have one, which is another reason why using
heuristics is the wrong approach:

https://wiki.linaro.org/WorkingGroups/Kernel/Projects/FlashCardSurvey?action=show&redirect=WorkingGroups%2FKernelConsolidation%2FProjects%2FFlashCardSurvey

> As I mentioned, I agree to push vendors to open those information all the time.
> And, I absolutely didn't mean that it is worth to wait vendors.
> I meant, until opening those information by vendors, something like
> proposing f2fs or gathering heuristics are also needed simultaneously.
> 
> Anyway, it's very interesting to build a database gathering products' information.
> May I access the database?

It's public information.

If you want to support different types of flash, then either add
your timing attack derived information on specific hardware to the
above table, or force vendors to update it themselves if they want
their flash memory supported by this filesystem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
