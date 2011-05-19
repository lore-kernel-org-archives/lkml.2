Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab1ESNxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:53:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140Ab1ESNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:53:38 -0400
Date: Thu, 19 May 2011 15:53:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86-64: Add time to vDSO
Message-ID: <20110519135336.GI12317@one.firstfloor.org>
References: <8f0d3bec51be8d9a2c37bac5aeb64c35cb387640.1305811184.git.luto@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f0d3bec51be8d9a2c37bac5aeb64c35cb387640.1305811184.git.luto@mit.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 09:24:48AM -0400, Andy Lutomirski wrote:
> The only fast implementation of time(2) we expose is through the
> vsyscall page and we want to get userspace to stop using the
> vsyscall page.  So make it available through the vDSO as well.

User space can just use vgettimeofday() and only take the seconds.
Adding time() too was a mistake back then.

And BTW just for seconds alone you wouldn't need the seqlock.

-Andi
