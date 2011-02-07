Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1BGJbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:31:06 -0500
Received: from oceanic.CalvaEDI.COM ([89.202.194.168]:42220 "EHLO
	oceanic.CalvaEDI.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab1BGJbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:31:04 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Feb 2011 04:31:03 EST
Message-ID: <4D4FBA89.606@Calva.COM>
Date: Mon, 07 Feb 2011 10:25:29 +0100
From: John Hughes <john@Calva.COM>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101227 Icedove/3.0.11
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tim Gardner <tim.gardner@canonical.com>
Subject: Re: x25: possible skb leak on bad facilities
References: <20110131130826.GC16804@shadowen.org>
In-Reply-To: <20110131130826.GC16804@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/01/11 14:08, Andy Whitcroft wrote:
> Looking at the changes introduced in the commit below, we seem to
> introduce an skb leak when a packet with bad facilities are present:
>
>      commit a6331d6f9a4298173b413cf99a40cc86a9d92c37
>      Author: andrew hendry<andrew.hendry@gmail.com>
>      Date:   Wed Nov 3 12:54:53 2010 +0000
>
>          memory corruption in X.25 facilities parsing
>
> If I am understanding things correctly then we trigger a -1 return to
> the main packet dispatch loop, this being non-zero implies that we have
> requeued the skb and it should not be freed.  As it was not requeued,
> I believe the skb is no longer referenced and then is leaked.
>
> Perhaps someone better aquainted with this code could review my analysis
> in the patch leader below.  If accurate I believe we need the patch below
> to resolve this.  If it is not then I suspect a comment is required on
> the -1 return.
>
> Thoughts?
>    
Sadly, after nearly 30 years (1982-2010) we've just closed our last X.25 
line so I can no longer test this.

Sorry.
