Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0EEXmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:42:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43310 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab0EEXme convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:42:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OK8uVQKFTQZD+2sQQHOa3c7+sc3DPcFj4pATUV0iOov1ZrhKjAYMtc2FfN74Tbguk
	OfyLWhjLs0AsdTMkzQdBw==
MIME-Version: 1.0
In-Reply-To: <87fx26ymrf.fsf@deeprootsystems.com>
References: <Pine.LNX.4.44L0.1005051554490.1885-100000@iolanthe.rowland.org>
	 <87fx26ymrf.fsf@deeprootsystems.com>
Date: Wed, 5 May 2010 16:42:29 -0700
Message-ID: <h2va55d774e1005051642m6159aadclfda9d1c77cb10cda@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Garrett <mjg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 4:03 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
>
> I guess what we're talking about here is a set of per-device
> constraints that could be used by both [opportunistic|system] suspend
> and runtime PM.  For lack of a better term, per-device PM QoS (as
> compared to the current system-wide PM QoS.)
>
> For example, if userspace (or some other device) has communicated that
> it has a constraint on the audio HW, then both the suspend path and the
> runtime PM path could check those constraints before making a decision
> on how to act.  Hopefully the phone app would set a constraint and the
> cow-noise app would not.  :)
>
> On OMAP, we keep track of per-device constraints (currently latency
> and throughput) in order to make proper run-time PM decicions in the
> kernel, but we are realizing that we need a way for userspace to
> communicate these constraints as well, so that userspace can make
> power vs. performance policy decisions instead of the kernel.
>
> Probably generalizing these into the LDM is the direction to go so
> userspace can set constraints on a per-device (or per-class?) basis:
>
> /sys/devices/.../power/constraint/throughput
> /sys/devices/.../power/constraint/wakeup_latency
> /sys/devices/.../power/constraint/... ?

The constraint stuff is definitely something I'd love to talk about in
detail.  It's a problem that I think is common to every SoC I've
worked with.  Having a general solution for this problem (of
specifying and observing various constraints for clock, power, qos,
etc) kernel-wide would seem like a big win.

Might be worth kicking some design ideas around and getting a bunch of
the interested parties together at some of the upcoming linux
conference things this fall on the east coast?

Brian
