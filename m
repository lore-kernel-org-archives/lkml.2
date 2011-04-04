Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1DDVnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:43:45 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:40391 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856Ab1DDVno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:43:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=MguIaj
	NZKPmjm1mlR33GBt+LmfZwDLSnaQA36VfyKc8Ny9q4cscz8JUjYv8iKRdkFugR3i
	yIImcj6aRDfEOQ0F1b8LLPl+1okUVcNBjYljryMqKEaEBn9/qcD4CLiBj7TDoaFg
	F3ekkigNhq+peVEDR0Ta1tO1G8I2Ol0dLDAmU=
Subject: Re: [PATCH 05/10] Core checkpoint/restart support code
From: Nathan Lynch <ntl@pobox.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, Andrew Morton <akpm@osdl.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <4D9A00B1.2080002@cs.columbia.edu>
References: <1298936432-29607-1-git-send-email-ntl@pobox.com>
 <1298936432-29607-6-git-send-email-ntl@pobox.com>
 <20110403190324.GD15044@hallyn.com> <1301929228.31531.39.camel@tp-t61>
 <20110404151017.GA4857@hallyn.com> <1301931608.31531.49.camel@tp-t61>
 <20110404162753.GA3456@hallyn.com>  <4D9A00B1.2080002@cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 16:43:29 -0500
Message-ID: <1301953409.31531.130.camel@tp-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: DC97A1EA-5F04-11E0-9570-E8AB60295C12-04752483!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 13:32 -0400, Oren Laadan wrote:
> From the technical point of view it *is* a big problem:  there are
> very good reasons why we chose a certain design. 
> 
> If Natahan is suggesting in-kernel tree creation as a temporary thing
> to simplify the code for review - then, given that this patch handles
> a single process, doing so add lots of unnecessary code, all of which
> in the kernel.
> 
> If this is the beginning of a permanent approach, then it is totally
> incompatible with what we have done so far, and severely restricts 
> the kind of use--cases of the project, potentially making it too
> unattractive for many natural adaptors, like HPC users. Sorry, nack.

It's not a stopgap measure to "ease review" or whatever; recreating the
task tree in-kernel is a fundamental - and simplifying - part of the
design.  I have earned through painful experience the opinion that
recreating the task tree in userspace is pretty much insane, as is
exposing the pid allocator to userspace via eclone(2), as is attempting
to support c/r of any resource that isn't isolated/virtualized, as is
having every recreated task "rendezvous" in the kernel by having them
all call restart(2), even though little significant work can be done in
parallel.

Time to try something different.

I don't see anything about in-kernel task tree creation that would
interfere with real-world use cases.


