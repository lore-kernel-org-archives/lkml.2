Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab0EFEZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 00:25:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46600 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab0EFEZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 00:25:19 -0400
MIME-Version: 1.0
In-Reply-To: <20100505234025.GB4838@opensource.wolfsonmicro.com>
References: <20100505185225.GA4411@srcf.ucam.org>
	 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
	 <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com>
	 <20100505234025.GB4838@opensource.wolfsonmicro.com>
Date: Wed, 5 May 2010 21:25:18 -0700
Message-ID: <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 4:40 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, May 05, 2010 at 01:56:07PM -0700, Brian Swetland wrote:
...
>> taken on MSM, regardless of suspend state.  I don't view suspend as
>> something that stops audio playback in progress.  Sort of similar to
>> how the modem doesn't power off down when the system is in suspend,
>> etc.
>
> This really does depend heavily on system design and the intended
> function of the suspend on the part of the initiator.  In many systems
> suspend will remove sufficient power to stop audio running even if it
> were desired, and there's the idea with existing manually initiated
> suspends that the system should stop what it's doing and go into a low
> power, low responsiveness state.  Some systems will initiate a suspend
> with active audio paths (especially those to or from the AP) which they
> expect to be stopped.
>

You can support both in the same driver in some cases (without a
switch). If the hardware cannot wake the system when it needs more
audio buffers, then the driver needs to block suspend while audio is
playing. Since suspend blockers only block opportunistic suspend, the
driver can also implement suspend to stop audio playback and it will
only be called for forced suspend.

-- 
Arve Hjønnevåg
