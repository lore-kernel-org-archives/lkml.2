Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab0FHXVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 19:21:10 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:38152 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751983Ab0FHXVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 19:21:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Mdp8ZoAiRbHlgxhpWaOP1EvR7Bs+8EwjeNtqEOBLkO+DTsSkenMUjAtwG5Pm8UOzsxkTKa419/TZQRsfl02tesesb94bdLyGU2RphnPeiHWjPbCdub9qsL129xO7hrL3;
Date: Tue, 8 Jun 2010 16:20:03 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Simmons <jsimmons@infradead.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@gmail.com>
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic
 time
Message-ID: <20100608162003.58aed526@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.1006061734060.1320@casper.infradead.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
	<20100519173449.6babbdfa@virtuousgeek.org>
	<alpine.LFD.2.00.1006061734060.1320@casper.infradead.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jun 2010 17:36:24 +0100 (BST)
James Simmons <jsimmons@infradead.org> wrote:

> 
> > On Fri, 9 Apr 2010 15:10:50 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > This set of 3 patches makes it a little more likely we'll get panic
> > > output onto the screen even when X is running, assuming a KMS enabled
> > > stack anyway.
> > > 
> > > It gets me from a blank or very sparsely populated black screen at
> > > panic time, to one including the full backtrace and panic output at
> > > panic time (tested with "echo c > /proc/sysrq-trigger" from an X
> > > session).
> > > 
> > > It doesn't cover every case; for instance I think it'll fail when X has
> > > disabled the display, but those cases need to be handled with separate
> > > patches anyway (need to add atomic DPMS paths for instance).
> > > 
> > > Anyway, please test these out and let me know if they work for you.
> > 
> > Ping Linus & Dave again.  Have you guys tried these?  Really, it's cool.
> 
> Is this safe with UMS and vgacon/sticon? With a oops while using vgacon 
> you can now touch the hardware buffer while not in vga text mode. 

Seems unlikely that poking VGA memory at that point would cause data
corruption.  There shouldn't be any other harm either, since the system
is already wedged...

-- 
Jesse Barnes, Intel Open Source Technology Center
