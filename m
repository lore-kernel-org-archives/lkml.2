Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1JYHFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:05:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27183 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1JYHFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:05:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=epWxAW1vmbgYnCwaHqdy8wQy7a5IS6ncx80V1y6ohgt3ruqjt02wFMqi4K3rHbTwd
	aofIhzSKyqx+BvNaNAP3w==
MIME-Version: 1.0
In-Reply-To: <20111024125034.71993780@notabene.brown>
References: <20111016092556.07d6e415@notabene.brown>
	<Pine.LNX.4.44L0.1110152136460.19724-100000@netrider.rowland.org>
	<20111017083717.0bd5626c@notabene.brown>
	<20111024011804.GB12215@mgross-G62>
	<20111024125034.71993780@notabene.brown>
Date: Tue, 25 Oct 2011 00:05:48 -0700
Message-ID: <CANqkERDBizgOkHjhN1TihQ41627Ow7CvFRHwhC6ZEa6+ve2mdA@mail.gmail.com>
Subject: Re: [markgross@thengar.org: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
From: Brian Swetland <swetland@google.com>
To: NeilBrown <neilb@suse.de>
Cc: markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 6:50 PM, NeilBrown <neilb@suse.de> wrote:
> But saying "Timeouts are never right" cannot work - unless you mean it in a
> much more restricted sense than I think you mean it.
>
> (I can agree that it is *best* if timeouts never fire - if direct action
> causes the wakeup-source to deactivate long before the timeout.  I agree that
> is the best case and probably should be the common case, but I cannot see how
> it can be the only case).

This was our conclusion when originally building the Android wakelock
APIs.  Timeouts are undesirable, and whenever we can ensure there's a
clear handoff of "ownership" of a wakeup event, so it's fully
accounted for, that's the preferred way to go.  But reality gives us
situations where we can't know with a certainty what woke us up (or we
won't know until some time has passed -- USB resume, etc) and in those
situations, timeouts are the best solution we have.  Over time we've
always hoped to have fewer and fewer timeouts, but I'm not certain
that we'll ever reach zero, for non-trivial systems.

Brian
