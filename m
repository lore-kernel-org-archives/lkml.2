Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab0ENQSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:18:21 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:59647 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab0ENQST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:18:19 -0400
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Alan Stern <stern@rowland.harvard.edu>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Linus Walleij <linus.walleij@ericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
References: <20100513191717.GA3428@atomide.com>
	<Pine.LNX.4.44L0.1005131729510.1731-100000@iolanthe.rowland.org>
	<20100513214739.GM3428@atomide.com>
	<AANLkTilL2mvqpwirTfJRWZFdrFJvSihnaY8-xao4pLpH@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 14 May 2010 09:18:15 -0700
In-Reply-To: <AANLkTilL2mvqpwirTfJRWZFdrFJvSihnaY8-xao4pLpH@mail.gmail.com> (Magnus Damm's message of "Fri\, 14 May 2010 12\:25\:26 +0900")
Message-ID: <87fx1uo3so.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Magnus Damm <magnus.damm@gmail.com> writes:

> Still not sure how the system wide suspend is different from Runtime
> PM and CPUidle from the hardware perspective...

At least on OMAP and other embedded SoCs I'm familiar with, there is
no difference from the hardware perspecitve.

However, I understand that on ACPI-based systems, there are low-power
that are only reachable via system-wide suspsend since ACPI does not
provide the kernel with fine-grained control to hit those states
during idle.

That being said, I don't think this should be an issue since
opportunistic suspend is currently targetted primarily at embedded HW
which has much more fine-grained power control than traditional
ACPI-based systems.

To me the only real difference between system-wide suspend and runtime
PM + CPUidle is the freezing of userspace.

As has been discussed elsewhere in this discussion, any alternative
solution must address the freezing/idling of userspace.  

Kevin
