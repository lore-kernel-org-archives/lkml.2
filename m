Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1DDPAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 11:00:45 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:39240 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab1DDPAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 11:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=trw5ix
	a6/v+e3RQo9RHndWUTI/tFDUnchHRjN85GtCmZShW4vIk8sk484giN1a1Aikcdf/
	DUdLxmTMrbkYWAt1OkwARkGEg84KieYYOlN6B/C5mBux0suo1ehL7Pa2jtsBLinA
	3iyybyE695BoyTvrp6lS1vO89+4y37iFS2ZMo=
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
From: Nathan Lynch <ntl@pobox.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        Oren Laadan <orenl@cs.columbia.edu>,
        Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <20110403190324.GD15044@hallyn.com>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 10:00:28 -0500
Message-ID: <1301929228.31531.39.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 8E22A4B6-5ECC-11E0-B60E-E8AB60295C12-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-03 at 14:03 -0500, Serge E. Hallyn wrote:
> Quoting ntl@pobox.com (ntl@pobox.com):
> > Only a pid namespace init task - the child process produced by a call
> > to clone(2) with CLONE_NEWPID - is allowed to call these.  The state
> 
> So you make this useful for your cases by only using this with
> application containers - created using lxc-execute, or, more precisely,
> using lxc-init as the container's init.  So a container running a stock
> distro can't be checkpointed.

Correct, a conventional distro init won't work, and application
containers are my focus for now, at least.


> Is this just to keep the patch simple for now, or is there some reason
> to keep this limitation in place?

I guess you're asking whether non-pid-init processes could be allowed to
use the syscalls?  I don't think so... almost certainly not restart(2).

I think that restriction keeps the implementation simple and the
semantics clear.  And init is uniquely positioned to carry out any setup
required (mounts, networking) before calling restart.


