Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab0EEWEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:04:07 -0400
Received: from smtp-out.google.com ([74.125.121.35]:3898 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501Ab0EEWEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:04:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=cvur/AcQQmkUL41Lct8dO3Xd8JBfLzGH3UHeVF3+j7aAVJbIUcipfyq2G4uKjr5hT
	5bb3XuFUmtl/Ybqrx61Kw==
MIME-Version: 1.0
In-Reply-To: <20100505215711.GA4838@opensource.wolfsonmicro.com>
References: <20100505185225.GA4411@srcf.ucam.org>
	 <20100505195534.GD18762@thunk.org>
	 <20100505202637.GH7139@rakim.wolfsonmicro.main>
	 <201005052244.03225.rjw@sisk.pl>
	 <20100505215711.GA4838@opensource.wolfsonmicro.com>
Date: Wed, 5 May 2010 15:03:55 -0700
Message-ID: <g2ua55d774e1005051503m232aa409pd2c9a12a2d4888ba@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tytso@mit.edu,
       Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 2:57 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 05, 2010 at 10:44:03PM +0200, Rafael J. Wysocki wrote:
>
>> To me, the above may be summarized that in your opinion some components of
>> the system will generally need to stay powered when it's suspended
>> opportunistically, so we need an interface to specify which components they are.
>> Is that correct?
>
> Yes, though I think I'd be inclined to treat the problem orthogonally to
> opportunistic suspend to allow more flexibility in use and since
> treating it as part of opportunistic suspend would imply that there's
> some meaningful difference between the end result of that and a manual
> suspend which AIUI there isn't.

I'd agree with this.  This is one of the reasons I haven't felt
opportunistic suspend is a big departure from other work here -- there
are always some cases in which drivers will need to keep external
resources active even when suspended.  Also, as I mentioned earlier,
we (Android at least, but hopefully this is non-controversial) would
always like drivers to put everything in the lowest possible power
state they can get away with.  Every little savings adds up.

Brian
