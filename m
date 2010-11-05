Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0KEMiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 08:38:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47610 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0KEMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 08:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=UyNeIUqJ//tlhU1FnFW3pDSghtrEdOgwijMRSdUDUGaQW888ukwQvMTDDAVDfKIZE0
         wPMBkpVqQvsQvHHbKsQcFFrUbicLcViJ6tF1QU5BO3OzBQMzw7CEU2j+8Pzv+drRLuVT
         vzJEPrL1c/M1gXRDKBavi84x6XK1EUkA52Q3Y=
From: Francis Moreau <francis.moro@gmail.com>
To: Victor Jimenez <victor.javier@bsc.es>
Cc: Reid Kleckner <reid.kleckner@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.SSgtQesEhEQa5DUYUwBV3fWtoV4@ifi.uio.no>
	<fa.dD5ur5Phqa1TLmYBE2NVKCQMjTw@ifi.uio.no>
	<fa.Xj1lA7n6nIJYL40CeRDpQzSKlfc@ifi.uio.no>
	<fa.xcyA+VzIXesq6qsPU6ADM4xdCKY@ifi.uio.no>
	<fa.MOg61Pcfdp2SJnwM2GFdOxP+xt0@ifi.uio.no>
	<fa.4sHfhlc/fMhpYgKda4IfUHZ7jMY@ifi.uio.no>
Date: Fri, 05 Nov 2010 13:38:12 +0100
In-Reply-To: <fa.4sHfhlc/fMhpYgKda4IfUHZ7jMY@ifi.uio.no> (Victor Jimenez's
	message of "Thu, 04 Nov 2010 22:36:15 UTC")
Message-ID: <m2wros3pzf.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Victor Jimenez <victor.javier@bsc.es> writes:

[...]

> If you are measuring last level cache misses, I would recommend you to
> use a memory intensive application/benchmark instead of /bin/true, as
> otherwise there can be a significant variation between two runs.

I agree.

But still with intensive application, I got the same results:


  $ perf stat -r3 -e cache-misses:u gzip -9 -c vmlinux.o >/dev/null

   Performance counter stats for 'gzip -9 -c vmlinux.o' (3 runs):

               950704  cache-misses               ( +-  24.925% )

         82.619412905  seconds time elapsed   ( +-   0.072% )


  $ perf stat -r3 -e llc-load-misses:u,llc-store-misses:u gzip -9 -c vmlinux.o >/dev/null

   Performance counter stats for 'gzip -9 -c vmlinux.o' (3 runs):
  
               317054  LLC-load-misses            ( +-  11.758% )
               162634  LLC-store-misses           ( +-   9.700% )

         82.657099783  seconds time elapsed   ( +-   0.167% )

Thanks
-- 
Francis
