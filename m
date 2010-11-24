Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0KXLeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:34:11 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:44178 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab0KXLeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:34:10 -0500
Date: Wed, 24 Nov 2010 11:34:05 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] MIPS: Fix CP0 COUNTER clockevent race
Message-ID: <20101124113404.GA30204@linux-mips.org>
References: <8a8eee995454c8b271cceb440e31699a@localhost>
 <444ef6c4bbb47d55c700452d8cd23229@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444ef6c4bbb47d55c700452d8cd23229@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 10:26:44AM -0800, Kevin Cernekee wrote:

> write_c0_compare(read_c0_count());
> 
> Even if the counter doesn't increment during execution, this might not
> generate an interrupt until the counter wraps around.  The CPU may
> perform the comparison each time CP0 COUNT increments, not when CP0
> COMPARE is written.
> 
> If mips_next_event() is called with a very small delta, and CP0 COUNT
> increments during the calculation of "cnt += delta", it is possible
> that CP0 COMPARE will be written with the current value of CP0 COUNT.
> If this is detected, the function should return -ETIME, to indicate
> that the interrupt might not have actually gotten scheduled.

Good catch - though on real hardware it should be theoretical as the
minimum timer interval is 300ns.  So it should only be trigerable on
a very slow system like a hardware emulator or maybe if a software
emulator like qemu gets rescheduled between the update and the read-back.

Applied,

  Ralf
