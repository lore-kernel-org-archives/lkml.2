Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1A1BWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:22:51 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:33728 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752680Ab1A1BWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:22:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAEapQU1Ld/sX/2dsb2JhbAAMhAjNLZBdgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,388,1291611600"; 
   d="scan'208";a="89494157"
Message-ID: <4D421A68.9000607@teksavvy.com>
Date: Thu, 27 Jan 2011 20:22:48 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Stan Hoeppner <stan@hardwarefreak.com>,
        Justin Piszcz <jpiszcz@lucidpixels.com>,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
References: <4D40C8D1.8090202@teksavvy.com> <20110127033011.GH21311@dastard> <4D40EB2F.2050809@teksavvy.com> <4D418B57.1000501@teksavvy.com> <alpine.DEB.2.00.1101271040000.31246@p34.internal.lan> <4D419765.4070805@teksavvy.com> <4D41CA16.8070001@hardwarefreak.com> <4D41EA04.7010506@teksavvy.com> <20110128001735.GO21311@dastard>
In-Reply-To: <20110128001735.GO21311@dastard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-27 07:17 PM, Dave Chinner wrote:
>
> In my experience with XFS, most people who tweak mkfs parameters end
> up with some kind of problem they can't explain and don't know how
> to solve. And they are typically problems that would not have
> occurred had they simply used the defaults in the first place. What
> you've done is a perfect example of this.

Maybe.  But what I read from the paragraph above,
is that the documentation could perhaps explain things better,
and then people other than the coders might understand how
best to tweak it.

> Why 8 AGs and not the default?

How AGs are used is not really explained anywhere I've looked,
so I am guessing at what they do and how the system might respond
to different values there (that documentation thing again).

Lacking documentation, my earlier experiences suggest that more AGs
gives me less fragmentation when multiple simultaneous recording streams
are active.  I got higher fragmentation with the defaults than with
the tweaked value.

Now, that might be due to differences in kernel versions too,
as things in XFS are continuously getting even better (thanks!),
and the original "defaults" assessment was with the kernel-of-the-day
back in early 2010 (2.6.34?), and now the system is using 2.6.37.

But I just don't know.  My working theory, likely entirely wrong,
is that if I have N streams active, odds are that each of those
streams might get assigned to different AGs, given sufficient AGs >= N.

Since the box often has 3-7 recording streams active,
I'm trying it out with 8 AGs now.

Cheers

