Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684Ab0IWVyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:54:31 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:59255 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754972Ab0IWVya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:54:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Zk9ljOIqAAHWT3mVXZ+EeP+snHRutEwuUK5jK0XicKbOZjII0EIofc0T6osjgy5WWaLHE0nYSHYY8MCd8o0T9Q7aMU+yZQw7hPx8EIvS1CmDLj0ZXpNScxB+pBIyfNFm;
Date: Thu, 23 Sep 2010 14:54:28 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tim.gardner@canonical.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MCP limit log messages, 2.6.36-rc4
Message-ID: <20100923145428.4805adcb@jbarnes-desktop>
In-Reply-To: <20100923134816.57e932fc@jbarnes-desktop>
References: <4C9106C1.4080505@canonical.com>
	<20100923134816.57e932fc@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 13:48:16 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Wed, 15 Sep 2010 11:47:45 -0600
> Tim Gardner <tim.gardner@canonical.com> wrote:
> 
> > I've been getting regular MCP limit log messages on a Dell Studio 1458 
> > (i5 CPU) with an A02 BIOS. With the attached debug hack it prints the 
> > following values:
> > 
> > [   33.605098] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> > 30123, limit 1023
> > [   38.597998] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> > 21697, limit 1023
> > [   43.590917] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> > 15390, limit 1023
> > [   48.583821] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> > 43370, limit 1023
> > [   53.576740] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> > 64728, limit 1023
> > 
> > This is an idle machine which starts printing these messages about 30 
> > seconds after boot. Any thoughts?
> 
> Actually, it looks like you have some non-upstream patches to the IPS
> driver, maybe one of Joe's patches to add more debug output when limits
> are exceeded?
> 
> At any rate, I think we're setting the MCP power limit incorrectly.
> The BIOS must be giving us a limit in 0.1W units (though even then it
> looks bogus); we need to clamp it to one of the available defaults.
> 
> Joe has some code for that as well, I've just asked him to update his
> patch, which we should get into 2.6.35.x.

Just posted some fixes for this to the x86 driver list, in particular
the "[PATCH 2/2] IPS driver: verify BIOS provided limits" should help a
bit here, but I still have a bug to fix in the i915 driver to really
make things work.

-- 
Jesse Barnes, Intel Open Source Technology Center
