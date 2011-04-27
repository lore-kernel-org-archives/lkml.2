Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab1D0S0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:26:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61380 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757137Ab1D0S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L/zjVsMF0aorsUK9FafE3oKfPH1wh7RrQYJBsZbOFQust+EHz1yEy0UopjHE8BtAJw
         jaE2f6Jm9tkMsVxXO6fs7ehtlel3mYoVZBLoQ/jU4+KmVtf4H4nHIrvfDaoNf3ozt++Z
         lafC8yV4yx5oZcrexTeEq5y8TxwNEYme/l068=
Date: Wed, 27 Apr 2011 20:26:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
Message-ID: <20110427182633.GB1753@nowhere>
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com>
 <1303923602-2923-4-git-send-email-fweisbec@gmail.com>
 <4DB854AA.6070101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB854AA.6070101@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 10:38:50AM -0700, H. Peter Anvin wrote:
> On 04/27/2011 09:59 AM, Frederic Weisbecker wrote:
> > So that hw_breakpoints and perf can be not built on
> > specific embedded systems.
> 
> How big of a win, if any, is this, really?
> 
> 	-hpa

That's pretty significant, because if you can disable breakpoints,
then you can disable perf. Together they make quite a chunk.

breakpoints + perf:

   text	   data	    bss	    dec	    hex	filename
1567422	 348628	 511680	2427730	 250b52	vmlinux


none:

   text	   data	    bss	    dec	    hex	filename
1478031	 333220	 508256	2319507	 236493	vmlinux
