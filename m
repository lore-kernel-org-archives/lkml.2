Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab0EDTGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 15:06:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36104 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932121Ab0EDTGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 15:06:48 -0400
Date: Tue, 4 May 2010 20:06:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100504190656.GA4611@opensource.wolfsonmicro.com>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <87wrvl5479.fsf@deeprootsystems.com>
 <20100503180741.GB2098@rakim.wolfsonmicro.main>
 <201005032318.35383.rjw@sisk.pl>
 <87sk68r1zh.fsf@deeprootsystems.com>
 <s2qd6200be21005031709r28420f0ezf3cf286517ee9114@mail.gmail.com>
 <w2pa55d774e1005031743x859e82fz401346fae7fe873a@mail.gmail.com>
 <20100504135907.GA3651@opensource.wolfsonmicro.com>
 <87r5lrh780.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r5lrh780.fsf@deeprootsystems.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 11:06:39AM -0700, Kevin Hilman wrote:

> With opportunistic suspend, all of this flexibility is gone, and the
> device/subsystem is told to go into the lowest power, highest latency
> state, period.

Well, half the problem I have is that unfortunately it's not a case of
doing that period.  The prime example I'm familiar with is that for
understandable reasons users become irate when you power down the audio
CODEC while they're in the middle of a call so if opportunistic PM is in
use then the audio subsystem needs some additional help interpreting a
suspend request so that it can figure out how to handle it.  Similar
issues apply to PMICs, though less pressingly for various reasons.

Just to be clear, I do understand and mostly agree with the idea that
opportunistic suspend presents a reasonable workaround for our current
inability to deliver good power savings with runtime PM methods on many
important platforms but I do think that if we're going to make this
standard Linux PM functionality then we need to be clearer about how
everything is intended to hang together.
