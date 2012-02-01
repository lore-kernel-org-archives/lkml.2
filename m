Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2BAR5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:57:01 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:27484 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753026Ab2BAR47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:56:59 -0500
Date: Wed, 1 Feb 2012 12:56:51 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Keith Packard <keithp@keithp.com>
Subject: Re: Linux 3.3-rc2
Message-ID: <20120201175651.GA3300@elliptictech.com>
References: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFye5iedspjus4YLi+r77Xq74bCq+MqU0HrTmDC5Dveivg@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-31 13:59 -0800, Linus Torvalds wrote:
> Ok, so for no real reason at all - except me being disorganized and
> just not thinking about it - rc2 is several days delayed. It's closer
> to two weeks rather than the standard one week I try to have between
> rc's.
[...]
> Go forth and test.

So, the HDMI log spam I reported against 3.2-rc1 in this thread:

  http://permalink.gmane.org/gmane.linux.kernel/1212638

is actually slightly worse now (see below), despite the fact that it was
eliminated by the patch I tested.  Looking at the git log, I see a patch
similar to the one sent to me was merged as part of a larger series:

  3a9627f4fbb0 ("drm/i915: dont trigger hotplug events on unchanged ELD")

and indeed, by building the tree after checking out that specific commit
there is no spam.  However, the _very next commit_:

  2deed761188d ("drm/i915: HDMI hot remove notification to audio driver")

reintroduces the log spam every mode change, with two additional lines
printed each time (the lines prefixed with an asterisk are new):

* HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=0 ELD_Valid=1
* HDMI status: Codec=3 Pin=3 Presence_Detect=0 ELD_Valid=0
  HDMI hot plug event: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
  HDMI status: Codec=3 Pin=3 Presence_Detect=1 ELD_Valid=1
  HDMI: detected monitor W2253 at connection type HDMI
  HDMI: available speakers: FL/FR
  HDMI: supports coding type LPCM: channels = 2, rates = 32000 44100 48000, bits = 16 20 24

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

