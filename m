Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1GER4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:56:15 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52119 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab1GER4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:56:13 -0400
Date: Tue, 5 Jul 2011 21:56:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [Q x86-64] on kernel_eflags
Message-ID: <20110705175609.GF4060@sun>
References: <20110705104742.GO17941@sun>
 <4E134E1E.6040304@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E134E1E.6040304@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:47:10AM -0700, H. Peter Anvin wrote:
> On 07/05/2011 03:47 AM, Cyrill Gorcunov wrote:
> > 
> > Should not every cpu has own copy of kernel_eflags? Just
> > to be consistent in style? Or this would be space waisting
> > and an optimization is done here?
> > 
> 
> Not specific to this particular case, but in general: a shared variable
> that used often but rarely written to will automatically replicate
> itself in the caches of multiple processors.  This is the purpose of the
> read_mostly segment (writes are permitted but expected to be rare),
> which exists to make sure that a frequently written variable doesn't
> randomly end up in the cache line next to a read-mostly variable.
> 
> 	-hpa
> 

yeah, thanks peter!

	Cyrill
