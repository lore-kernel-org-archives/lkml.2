Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab2GZRy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 13:54:28 -0400
Received: from osrc3.amd.com ([217.9.48.20]:43118 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752547Ab2GZRy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 13:54:27 -0400
Date: Thu, 26 Jul 2012 19:54:21 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 12/13] driver core: firmware loader: use small
 timeout for cache device firmware
Message-ID: <20120726175421.GB9161@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-13-git-send-email-ming.lei@canonical.com>
 <20120726123655.GE30717@aftab.osrc.amd.com>
 <CACVXFVOvkdCG_cAsCQPuNQB_4BnXq8f=+RnVXH=NS5GNPvQgtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOvkdCG_cAsCQPuNQB_4BnXq8f=+RnVXH=NS5GNPvQgtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 11:48:17PM +0800, Ming Lei wrote:
> On Thu, Jul 26, 2012 at 8:36 PM, Borislav Petkov <bp@amd64.org> wrote:
> > On Wed, Jul 25, 2012 at 01:00:12AM +0800, Ming Lei wrote:
> >> Because device_cache_firmwares only cache the firmware which has been
> >> loaded sucessfully at leat once, using a small loading timeout should
> >
> >                         least
> >
> >> be OK.
> >
> > Your commit message doesn't explain why exactly we decrease the timeout:
> 
> I have explained it. Because the firmware has been loaded successfully at least
> once, so it is very probably to not timeout.
> 
> > you should probably say that this patch overrides the default 60s
> > timeout because we're in pre-suspend/-hibernate mode where we have
> > userspace and are able to load the firmware quickly.
> 
> No, it is not what I was saying.

Ok, maybe I'm not understanding this then. So explain to me this: why
do you need that timeout value of 10, how did we decide it to be 10
(and not 20 or 30 or whatever)? Generally, why do we need to reprogram
the timer to a smaller timeout instead of simply doing the completion
without a timeout?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
