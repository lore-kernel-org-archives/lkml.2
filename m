Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1HCTpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 15:45:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab1HCToz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 15:44:55 -0400
Date: Wed, 3 Aug 2011 15:44:38 -0400
From: Don Zickus <dzickus@redhat.com>
To: ZAK Magnus <zakmagnus@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v3 2/2] Make hard lockup detection use timestamps
Message-ID: <20110803194438.GA20762@redhat.com>
References: <CAAuSN93tiSehpNXxjOgrq7oV-U+1ZPi2eqr+2dNSBG0yu0jxmA@mail.gmail.com>
 <20110725124451.GA2866@redhat.com>
 <CAAuSN93Qjk4eEAvm_Xn=O-0t+qhAyKmxy6HyPuyzJ35tX2u_CQ@mail.gmail.com>
 <20110729205538.GD14343@redhat.com>
 <CAAuSN93ouWrPn9xWb9Zd3E2Dp0hQxC4JmFH1utbyy1_aMnfkLA@mail.gmail.com>
 <20110801125234.GE14343@redhat.com>
 <CAAuSN92UAjuJXprBAj9z0sekk=iBWGe3PP88z8NmrZ5fExOyjg@mail.gmail.com>
 <20110801192407.GE2581@redhat.com>
 <CAAuSN92zxF9ZDuMhgrB_sBUrt+O4jGJ=AMe_iNMYSwXo9o79Kw@mail.gmail.com>
 <CAAuSN92zumHAOvthSYEQ5FqjpX_p2uw_WhDCb4ubHtEg9+vbpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAuSN92zumHAOvthSYEQ5FqjpX_p2uw_WhDCb4ubHtEg9+vbpg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 11:27:16AM -0700, ZAK Magnus wrote:
> An update:
> 
> I realized that the timing function I was using was no good. On x86 it
> will try to use the TSC but if it can't (which, as I understand, isn't
> a very rare case), it will fall back on a jiffies-based solution. If
> interrupts are disabled, time would appear to "stand still" and
> lockups wouldn't be detected. So, looks like I have to nix this
> particular patch and not change the hard lockup detection that much.

Hmm, I was initially worried about that, but after seeing the function
you were using assuming Peter vetted it properly to use cleanly from an
NMI context.  I guess I didn't fully understand the limitations of it.

> 
> Meanwhile, I'm working on printing stack traces to a buffer/out to
> file. I got some help and it looks like it's not that hard to do. I'll
> send it when it's ready.

Interesting.  I look forward to seeing it.

Cheers,
Don

