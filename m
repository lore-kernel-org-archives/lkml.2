Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab2G0Bya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 21:54:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38961 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab2G0By3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 21:54:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120726175421.GB9161@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-13-git-send-email-ming.lei@canonical.com>
	<20120726123655.GE30717@aftab.osrc.amd.com>
	<CACVXFVOvkdCG_cAsCQPuNQB_4BnXq8f=+RnVXH=NS5GNPvQgtg@mail.gmail.com>
	<20120726175421.GB9161@aftab.osrc.amd.com>
Date: Fri, 27 Jul 2012 09:54:25 +0800
Message-ID: <CACVXFVM5VhaqKRcWu-6Hj_ja4OrEA63udcL_sLoSWtQm4NFNag@mail.gmail.com>
Subject: Re: [RFC PATCH 12/13] driver core: firmware loader: use small timeout
 for cache device firmware
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 1:54 AM, Borislav Petkov <bp@amd64.org> wrote:

>> No, it is not what I was saying.

I just mean the point is not mentioned in my commit log, but I admit it should
be a appropriate cause.

>
> Ok, maybe I'm not understanding this then. So explain to me this: why
> do you need that timeout value of 10, how did we decide it to be 10

If one firmware image was loaded successfully before, the probability of
loading it successfully at this time should be much higher than the 1st time
because something crazy(for example, the firmware is deleted) happens
with low probability.

Choosing 10 secs is just a estimation for loading time because the maximum
size of firmware in current distributions is about 2M bytes, since we know
it has been loaded successfully before.

> (and not 20 or 30 or whatever)? Generally, why do we need to reprogram
> the timer to a smaller timeout instead of simply doing the completion
> without a timeout?

No, it should be crazy without a timeout, and it can be triggered in init call
easily.


Thanks,
--
Ming Lei
