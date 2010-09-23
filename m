Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab0IWUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:48:22 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:54624 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755358Ab0IWUsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:48:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hg5ckP2oayjeqt9F19P4tsUGvldhqBaJFfKMWXzt+F3HhsMCBYJHvjzcBYsB/kUPBLqQ2uYRo6+DAmwJTTebb5LttoX5wFjwtYvOy+U7X6mmm2K1oH0NkjekQ9T3Gdpi;
Date: Thu, 23 Sep 2010 13:48:16 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: tim.gardner@canonical.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MCP limit log messages, 2.6.36-rc4
Message-ID: <20100923134816.57e932fc@jbarnes-desktop>
In-Reply-To: <4C9106C1.4080505@canonical.com>
References: <4C9106C1.4080505@canonical.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 11:47:45 -0600
Tim Gardner <tim.gardner@canonical.com> wrote:

> I've been getting regular MCP limit log messages on a Dell Studio 1458 
> (i5 CPU) with an A02 BIOS. With the attached debug hack it prints the 
> following values:
> 
> [   33.605098] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> 30123, limit 1023
> [   38.597998] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> 21697, limit 1023
> [   43.590917] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> 15390, limit 1023
> [   48.583821] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> 43370, limit 1023
> [   53.576740] intel ips 0000:00:1f.6: MCP limit exceeded: Avg power 
> 64728, limit 1023
> 
> This is an idle machine which starts printing these messages about 30 
> seconds after boot. Any thoughts?

Actually, it looks like you have some non-upstream patches to the IPS
driver, maybe one of Joe's patches to add more debug output when limits
are exceeded?

At any rate, I think we're setting the MCP power limit incorrectly.
The BIOS must be giving us a limit in 0.1W units (though even then it
looks bogus); we need to clamp it to one of the available defaults.

Joe has some code for that as well, I've just asked him to update his
patch, which we should get into 2.6.35.x.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
