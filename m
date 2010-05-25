Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab0EYBQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 21:16:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55722 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306Ab0EYBQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 21:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <20100524185754.GD1292@ucw.cz>
References: <1272667021-21312-1-git-send-email-arve@android.com>
	 <87wrvl5479.fsf@deeprootsystems.com>
	 <20100503215028.GB18910@srcf.ucam.org> <20100524185754.GD1292@ucw.cz>
Date: Mon, 24 May 2010 18:16:15 -0700
Message-ID: <AANLkTilR3CgkLRfxMN_A79kuC_KOgsfW4oNUDPZFlZFW@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Matthew Garrett <mjg@redhat.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 11:57 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> I agree that the runtime scenario is a far more appealing one from an
>> aesthetic standpoint, but so far we don't have a very compelling
>> argument for dealing with the starting and stopping of userspace. The
>> use-cases that Google have provided are valid and they have an
>> implementation that addresses them, and while we're unable to provide an
>> alternative that provides the same level of functionality I think we're
>> in a poor position to prevent this from going in.
>
> Uhuh?
>
> "We have this ugly code here, but it works and we don't have better
> one, so lets merge it"?
>
> I don't really like this line of reasoning. I would not want to judge
> wakelocks here, but... "it works, merge it" should not be used as
> argument.
>
> And btw I do have wakelock-less implementation of autosleep, that only
> sleeped the machine when nothing was ready to run. It was called
> "sleepy linux". Should I dig it out?
>
> Major difference was that it only sleeped the machine when it was
> absolutely certain machine is idle and no timers are close to firing
> -- needing elimination or at least markup of all short timers. It
> erred on side of not sleeping the machine when it would break
> something.
>

How did you handle external events that occur right after you decided to sleep?

> Still I believe it is better design than wakelocks -- that need
> markup/fixes to all places where machine must not sleep -- effectively
> sleeping the machine too often than fixing stuff with wakelocks all
> over kernel and userspace...

-- 
Arve Hjønnevåg
