Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab1DDVVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:21:07 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:63004 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab1DDVVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=u28Ad2
	a/kmy+HO4gS+fyxubXp2I2JE5o/DOyvz2qWq0ytp+slv36vusYp6EYTVCx/9puQD
	wBC5HfVKPF9j9HPjcmKaxwhxp5c1SlJuPz5V/mTHqh+Bd24gg8zdfXyAILqsM3RM
	ovbaT5GCI5hweKIT820dpqPPo9z5qtii2Mr5c=
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
From: Nathan Lynch <ntl@pobox.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Oren Laadan <orenl@cs.columbia.edu>, Andrew Morton <akpm@osdl.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20110404162753.GA3456@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com> <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com> <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 16:20:46 -0500
Message-ID: <1301952046.31531.112.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: B019C5EC-5F01-11E0-9277-E8AB60295C12-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 11:27 -0500, Serge E. Hallyn wrote:
> Quoting Nathan Lynch (ntl@pobox.com):
> > On Mon, 2011-04-04 at 10:10 -0500, Serge E. Hallyn wrote:
> > > I'm asking whether you are intending to later on change the checkpoint
> > > API to allow an external task to checkpoint a pid-init process, rather than
> > > the pid-init process having to initiate it itself.
> > 
> > No, that is not the intention.  I can see how that would be problematic
> > for those wanting to run minimally-modified distro containers, but I
> > think running a patched pid-init is a reasonable tradeoff to ask users
> > to make in order to get c/r.  And there's nothing to keep the standard
> > distro inits from growing c/r capability.
> 
> It's not necessarily a dealbreaker, since presumably I can hack the
> needed support into upstart, triggered by a boot option so it isn't
> activated on a host.  But especially given the lack of interest in
> this thread so far, I don't see a point in pushing this, an API-incompatible
> less-capable version of the linux-cr tree.

The apparent lack of interest was discouraging, but I appreciate that
you've been looking it over.


>   If it can gain traction
> better than linux-cr, that'd be one thing.  But given the amount of
> review and testing the other tree has gotten

How much traction do you think linux-cr has?  It doesn't seem any closer
to mainline than it was a year ago, and it barely has any users.  I
don't think posting this little proof-of-concept patch set is disrupting
linux-cr's progress toward mainline.


>  - and I realize you're
> able to piggy-back on much of that - and, again, the lack of responses
> so far, I just don't see this as worth pushing for.

Sure, the lack of response sucks, but it's not unexpected, and the code
here is pretty rough (especially the stuff I wrote).  What I hoped to
highlight and discuss were the differences in system call interfaces and
goals, and to gauge interest from the larger community.  Certainly what
I posted here isn't anywhere close to merge quality and I didn't intend
it to be taken that way.  I don't think it's hurting anything to explore
an alternative approach with more modest goals (and, one hopes, less of
a maintenance footprint on the rest of the kernel).


> I'd really prefer that everyone was using the same tree, and sending
> any and all patches which they need, no matter how ugly they fear
> they are, upstream.  To that end, I think it would be appropriate
> for you or Dan to get write access to Oren's tree or to move to a
> newly cloned copy of his tree to which one of you has acces.

Oren and I disagree on some fundamental aspects of how kernel c/r should
be implemented (hence this patch set), so I'm not sure how this would
work.


