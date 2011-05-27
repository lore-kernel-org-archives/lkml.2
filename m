Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab1E0QHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 12:07:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34925 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab1E0QHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 12:07:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Date: Fri, 27 May 2011 18:07:20 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl> <4DDED4ED.7020806@zytor.com>
In-Reply-To: <4DDED4ED.7020806@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105271807.21310.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 27, 2011, H. Peter Anvin wrote:
> On 05/26/2011 03:18 PM, Rafael J. Wysocki wrote:
> > 
> > Well, as far as I can tell, this feature is going to break hibernation on
> > both x86_32 and x86_64 at the moment, unless you can guarantee that the
> > randomized kernel location will be the same for both the boot and the target
> > kernels.
> > 
> 
> Obviously we can't and we don't.  I'm a bit surprised at that
> constraint... how can that constraint not break things like kernels of
> slightly different size?

Our hibernation code generally requires that the kernel used for loading
the image be the same as the hibernated one.  This requirement is slightly
lifted for x86_64, but still we don't have a mechanism for passing the
jump address into the hibernated header in the image header.

I planned to add that, but then didn't have the time to work on it.

Thanks,
Rafael
