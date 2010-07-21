Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab0GURju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 13:39:50 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:52687 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0GURjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 13:39:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=subject:from:to
	:cc:in-reply-to:references:content-type:date:message-id
	:mime-version:content-transfer-encoding; q=dns; s=sasl; b=TBZXIV
	ys1b9CTgRSM1ewn4pC7nJOVz1GGbALwOeGIlVFZOobF+gMz2K93YWciLmXKIS22e
	STIYiX3TamfeatyPpPfOVL833vjX/u81OXeyFAJqoNTJot/OcT96t6tmonTFIqS/
	WLYRrlwTnNq5ChaB6U+RD9IINOMXwyu9VYqOo=
Subject: Re: [PATCH] signalfd: fill in ssi_int for posix timers and message
 queues
From: Nathan Lynch <ntl@pobox.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>, stable@kernel.org
In-Reply-To: <20100720211018.e586c7ce.akpm@linux-foundation.org>
References: <1278117528.21917.354.camel@localhost>
 <20100720154205.667e95aa.akpm@linux-foundation.org>
 <1279683859.3030.121.camel@localhost>
 <20100720211018.e586c7ce.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 12:39:37 -0500
Message-ID: <1279733977.3030.256.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: F2A1994A-94EE-11DF-9DD7-9056EE7EF46B-04752483!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 21:10 -0700, Andrew Morton wrote:
> On Tue, 20 Jul 2010 22:44:19 -0500 Nathan Lynch <ntl@pobox.com> wrote:
> 
> > > So it's not 100% obvious that this change is desirable.  Does the
> > > functionality which this patch adds justify the introduction of these
> > > problems?
> > 
> > I think the change is desirable in that no user of the interface could
> > reasonably expect the current behavior with respect to the ssi_int
> > field, and that it reconciles signalfd's behavior with its design
> > intentions.  On the other hand, I noticed this discrepancy only because
> > I was cribbing signalfd's data structures for checkpoint/restart, not
> > because I am aware of any application that is affected, nor was I able
> > to find one using Google's code search.  It would be highly speculative
> > of me to say that no application depends on the current behavior, but it
> > is difficult to imagine a correctly functioning application that depends
> > on it.
> 
> It's not a matter of a current application depending on current
> behaviour!  The problem is that an application written in 2018 which
> depends on the _new_ behaviour will not work on 2.6.34.

Yes, I misinterpreted your concern, sorry.  But I've never understood
Linux to make promises with respect to forward compatibility at the
system call layer.  Bug fixes[1] and features[2] that, like this patch,
break that compatibility seem to have gone in without raising this
issue.

Am I mistaken?  Or has there been a change in policy I've missed?


[1] "signalfd: fix for incorrect SI_QUEUE user data reporting" (0859ab5)

[2] "hugetlb: add MAP_HUGETLB for mmaping pseudo-anonymous huge page
regions" (4e52780)


