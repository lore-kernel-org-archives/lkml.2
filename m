Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616Ab0EDXOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 19:14:46 -0400
Received: from mail-iw0-f203.google.com ([209.85.223.203]:42391 "EHLO
	mail-iw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934606Ab0EDXOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 19:14:45 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
References: <1272667021-21312-1-git-send-email-arve@android.com>
	<87r5lrh780.fsf@deeprootsystems.com>
	<20100504190656.GA4611@opensource.wolfsonmicro.com>
	<201005042237.56844.rjw@sisk.pl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 04 May 2010 16:14:40 -0700
In-Reply-To: <201005042237.56844.rjw@sisk.pl> (Rafael J. Wysocki's message of "Tue\, 4 May 2010 22\:37\:56 +0200")
Message-ID: <87wrvjdztr.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 04 May 2010, Mark Brown wrote:
>> On Tue, May 04, 2010 at 11:06:39AM -0700, Kevin Hilman wrote:
>> 
>> > With opportunistic suspend, all of this flexibility is gone, and the
>> > device/subsystem is told to go into the lowest power, highest latency
>> > state, period.
>> 
>> Well, half the problem I have is that unfortunately it's not a case of
>> doing that period.  The prime example I'm familiar with is that for
>> understandable reasons users become irate when you power down the audio
>> CODEC while they're in the middle of a call so if opportunistic PM is in
>> use then the audio subsystem needs some additional help interpreting a
>> suspend request so that it can figure out how to handle it.  Similar
>> issues apply to PMICs, though less pressingly for various reasons.
>> 
>> Just to be clear, I do understand and mostly agree with the idea that
>> opportunistic suspend presents a reasonable workaround for our current
>> inability to deliver good power savings with runtime PM methods on many
>> important platforms but I do think that if we're going to make this
>> standard Linux PM functionality then we need to be clearer about how
>> everything is intended to hang together.
>
> At the moment the rule of thumb is: if you don't need the opportunistic
> suspend, don't use it.  It is not going to be enabled by default on anything
> other than Android right now.

Sure, but there are driver authors and subsystem maintainers who care
about optimal PM in "normal" Linux *and* in Android.

As a PM maintainer for an embedded platform (OMAP) used in both, I
certainly care about both, so "disable it if you don't like it" is not
really an option.

IMO, driver/subsystem authors should not have to care if the userspace
is Android or not.  We should be working towards a world where Android
is not a special case.

Kevin
