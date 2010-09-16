Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0IPMt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:49:27 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:45939 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753774Ab0IPMtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:49:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=F5cPPPbzgoZ5eOFzxGjx5kigWFocwmxC6X/m+G6Y/lH9XMHMBG6lmc9Xn+ussH4M9TQbQ9aAyWik/p9pDK9cBrJEYPwlvNyyeGMvqdqQsaWIKCAntNKv27K2pruMHxa4;
Date: Thu, 16 Sep 2010 14:49:17 +0200
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tim.gardner@canonical.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MCP limit log messages, 2.6.36-rc4
Message-ID: <20100916144917.54d5f2b0@jbarnes-x201>
In-Reply-To: <4C911C60.4030105@canonical.com>
References: <4C9106C1.4080505@canonical.com>
	<4C911C60.4030105@canonical.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 195.83.197.141 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 13:20:00 -0600
Tim Gardner <tim.gardner@canonical.com> wrote:

> On 09/15/2010 11:47 AM, Tim Gardner wrote:
> > I've been getting regular MCP limit log messages on a Dell Studio
> > 1458 (i5 CPU) with an A02 BIOS. With the attached debug hack it
> > prints the following values:
> >
> > [ 33.605098] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> > 30123, limit 1023
> > [ 38.597998] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> > 21697, limit 1023
> > [ 43.590917] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> > 15390, limit 1023
> > [ 48.583821] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> > 43370, limit 1023
> > [ 53.576740] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power
> > 64728, limit 1023
> >
> > This is an idle machine which starts printing these messages about
> > 30 seconds after boot. Any thoughts?
> >
> > rtg
> 
> More clues:
> 
> [   13.426064] intel ips 0000:00:1f.6: Warning: CPU TDP doesn't match 
> expected value (found 25, expected 35)
> [   13.426086] intel ips 0000:00:1f.6: PCI INT C -> GSI 18 (level,
> low) -> IRQ 18
> [   13.426933] intel ips 0000:00:1f.6: IPS driver initialized, MCP
> temp limit 95
> 

Oh interesting, this looks like a slightly different problem than some
others have been seeing.  The power limit is listed at 1023 but the
reported value is looking at least 100x over that, so we may have a
reporting vs limit unit mismatch here.

I'm looking into finding a way to enable the thermal device which would
fix another problem we have with bogus thermal limits and reporting,
but yours is a separate problem.  I'll take a look at the sources and
double check my unit calculations...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
