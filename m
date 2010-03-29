Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab0C2Utm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:49:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41329 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab0C2Utc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jm/oPtNC1qMoyBeMfi5B0n4hPNjjagp+/OcJdiUSkiBFzw1bJSvsst5rtqV/wVyxP4
         5uANeEeyb3IbR46E5JVHpPMW8zmBYz9Hc2uqqu6IOT/XWE/hcLtdsLBB30sCsldOz2WU
         C3mS7W8MFurGl2gNSjahePheY2BBNpsbH8R34=
Date: Mon, 29 Mar 2010 22:49:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [BUG] fault while using perf callchains in sparc64
Message-ID: <20100329204931.GJ5101@nowhere>
References: <20100328043446.GA11748@nowhere> <20100329.130931.149161813.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329.130931.149161813.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 01:09:31PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Sun, 28 Mar 2010 06:34:49 +0200
> 
> > I get kernel crashes each time I use perf with callchains
> > on sparc 64.
> > 
> > It triggers with a simple:
> > 
> > 	perf record -a -f -g sleep 1
> 
> This should fix it, thanks again.


I merged your tree on latest -git and it works well.

Thanks!

Sorry, I have another bug report.

While building perf tools, or the kernel, or whatever, I often
get the following error in the middle:

	gcc: Internal error: Segmentation fault (program as)

And this in the logs:

	[ 1429.477049] as[2658]: segfault at 4054dfa8 ip 0000000000020690 (rpc 00000000700adcf4) sp 00000000ffcbf008 
error 30001 in as[10000+40000]

My gcc / as and everything in userspace is 32 bits but the kernel is a 64.

My config is the same as before.

Again, tell me everything you need to help debugging this.

Thanks.

