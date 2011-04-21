Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1DUSaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 14:30:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62738 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1DUSaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 14:30:18 -0400
Message-ID: <4DB077AF.7020909@nerdbynature.de>
Date: Thu, 21 Apr 2011 11:30:07 -0700
From: Christian Kujau <lists@nerdbynature.de>
User-Agent: Mozilla/5.0 (X11; U; en-US; rv:1.9) Gecko/20100401
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@infradead.org>,
        Michael Guntsche <mike@it-loops.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with 2.6.39-rc[123]]
References: <20110415035451@it-loops.com> <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com> <20110415042255.GC27928@infradead.org> <4DA7E202.4000307@fusionio.com> <alpine.DEB.2.01.1104211051490.18728@trent.utfs.org> <BANLkTim7SLt6TMqJQw35=tnACax0mE1URA@mail.gmail.com>
In-Reply-To: <BANLkTim7SLt6TMqJQw35=tnACax0mE1URA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:22SRFh2MjalnUcFpfEie1NspbfrSFguu526hjIkO1Ne
 oiEe71EdI1FfszsksN4F10DmYjB43zzrRTcMWgAgIuxFeV6E0K
 8pr5OCBpOR6PojwSu7IjMoXNCf61ApiBBHLoBJRWFaZ1D0224Y
 /CpWQGJdX7z9xsu/+Xv4sKoLHNjxFXcnu6iFzweTuoyfgN1VxE
 /Ql/qkwxii3PWPULZ119Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote on 2011-04-21 10:59 :
> As of right now, all _known_ block bugs should be fixed in the stuff I
> just pushed out, with the current top-of-tree being the merge of the
> IDE CD endless loop issue and the NULL ptr oops at elevator change
> time:

OK, thanks.

> That said, that udevd message of yours would imply a full root
> filesystem, which can cause any amount of issues at boot time..

My /dev is mounted as udev and is 10MB in size, which is more than
enough for kernels < 2.6.39. But with 2.6.39 something changed and
/dev/.udev/queue.bin is growing to 7 MB and more, udevd is spinning like
crazy and the OOM is reaping processes.

I'm currently in the middle of a bisect, with 11 steps to go on this
PowerBook G4 :-\

Thanks,
Christian.
-- 
make bzImage, not war
