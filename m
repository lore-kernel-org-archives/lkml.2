Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab0CZFKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 01:10:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:40802 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab0CZFKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 01:10:34 -0400
Message-ID: <4BAC41C4.4040900@suse.de>
Date: Fri, 26 Mar 2010 14:10:28 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] refcounting improvements in sysfs.
References: <20100324031829.2136.66489.stgit@notabene.brown> <4BAC3CE0.2010408@suse.de>
In-Reply-To: <4BAC3CE0.2010408@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One thing to add.

On 03/26/2010 01:49 PM, Tejun Heo wrote:
> Nice article.  In general, yeap, I agree it would be nice to have a
> working reference count abstraction.  However, kref along with kobject
> is a good example of obscurity by abstraction anti pattern.  :-)

I think one of the reasons why k* hasn't really worked as well as it
was orginally imagined to do is the way we - the kernel programmers -
think and work.  We add abstractions when something is functionally
necessary, so in a lot of cases the functional requirements become the
implementation and the communication among us (ie. serves as implied
documentation).  The k* stuff detracts from this principle.  Those
abstractions are there for the purpose of abstracting and our usual
mindset becomes very susceptible to misinterpretations as no easily
identifiable functional requirements are there - we either end up
imaginging something up or waste time frustrated trying to figure out
why the hell that abstraction is there.

This actualy is a very generic problem.  When a LOT of people are
trying to work together sharing a lot of infrastructures, it is very
deterimental to impose certain paradigm upon them.  People can easily
agree upon functional necessities but one guy's wildest, most
ambitious paradigmatic vision looks like a complete bull to another
gal.

So, let's keep the abstractions to the just necessary level and
communicate at the functional layer.  In this case, mount and sysfs
shares the requirement for a refcount w/ a kill switch.  I'm not sure
it warrants common abstraction at this stage but if the *function* can
be wrapped nicely along with lockdep annotations and all, why not?

Thanks.

-- 
tejun
