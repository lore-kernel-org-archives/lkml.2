Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab1BKMYa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:24:30 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38571 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1BKMY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:24:29 -0500
Date: Fri, 11 Feb 2011 12:24:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org,
        santosh.shilimkar@ti.com, Will Deacon <Will.Deacon@arm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] ARM: vfp: Use cpu pm notifiers to save vfp
	state
Message-ID: <20110211122410.GF23404@n2100.arm.linux.org.uk>
References: <1297373487-23902-1-git-send-email-ccross@android.com> <1297373487-23902-4-git-send-email-ccross@android.com> <1297426345.17584.99.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297426345.17584.99.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 12:12:25PM +0000, Catalin Marinas wrote:
> On SMP systems, we save the VFP at every context switch to deal with the
> thread migration (though I have a plan to make this lazily on SMP as
> well).

I'm not sure it's worth the complexity.  You'd have to do an IPI to the
old CPU to provoke it to save the context from its VFP unit.  You'd have
to do that in some kind of atomic way as the old CPU may be in the middle
of already saving it.  You're also going to have to add locking to the
last_VFP_context[] array as other CPUs will be accessing non-local
entries, and that means doing locking in assembly.  Yuck.

No, let's not go there.  Stick with what we currently have which works
well.
