Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1DDPkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:40:25 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:54539 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab1DDPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=ivz5uJ
	kgOuyxgy3Tw3ZsZUInrT3l07OYf4zSVu+BX/pznB8mvkJvTFKpWyLeBi55jV5UTK
	uE9rUz72bA4v5SEi+A5fzldHVqRqHG6vQy+++1kzMsTLQmHJVYIW3eEXcIft/b6+
	xah5lP3ezv+8cQf64ZMLtkYQL0b0GzDzI2pkw=
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
From: Nathan Lynch <ntl@pobox.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Oren Laadan <orenl@cs.columbia.edu>,
        Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20110404151017.GA4857@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com> <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 10:40:08 -0500
Message-ID: <1301931608.31531.49.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 183195C2-5ED2-11E0-9CF6-E8AB60295C12-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 10:10 -0500, Serge E. Hallyn wrote:
> Quoting Nathan Lynch (ntl@pobox.com):
> > On Sun, 2011-04-03 at 14:03 -0500, Serge E. Hallyn wrote:
> > > Quoting ntl@pobox.com (ntl@pobox.com):
> > > > Only a pid namespace init task - the child process produced by a call
> > > > to clone(2) with CLONE_NEWPID - is allowed to call these.  The state
> > > 
> > > So you make this useful for your cases by only using this with
> > > application containers - created using lxc-execute, or, more precisely,
> > > using lxc-init as the container's init.  So a container running a stock
> > > distro can't be checkpointed.
> > 
> > Correct, a conventional distro init won't work, and application
> > containers are my focus for now, at least.
> > 
> > 
> > > Is this just to keep the patch simple for now, or is there some reason
> > > to keep this limitation in place?
> > 
> > I guess you're asking whether non-pid-init processes could be allowed to
> > use the syscalls?
> 
> No.  I'm asking whether you are intending to later on change the checkpoint
> API to allow an external task to checkpoint a pid-init process, rather than
> the pid-init process having to initiate it itself.

No, that is not the intention.  I can see how that would be problematic
for those wanting to run minimally-modified distro containers, but I
think running a patched pid-init is a reasonable tradeoff to ask users
to make in order to get c/r.  And there's nothing to keep the standard
distro inits from growing c/r capability.


