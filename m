Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab0FFKmf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:42:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36082 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab0FFKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:42:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NjA1icKLsWWX5/lAnNVZzC6+CWqCDAKHC7hCM8lZ6mK/ZUkPp27BKLKV23gGxHwmVK
         aOFe6BYV5BC3hSFQ6MUXicZDIlcFN37fWBM0+w6dcQ+R5JMlAtkjNmyCkPQxlP49Lvgi
         yHyHyGzRt8TSNlWPwb1Y9Xt3/UvMpeCZZ8+rM=
Subject: Re: [2.6.35-rc1] page alloc failure order:1, mode:0x4020
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Michael Guntsche <mike@it-loops.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <20100606095640.GA4436@trillian.comsick.at>
References: <20100604092025.GA96690@trillian.comsick.at>
	 <1275656014.2482.169.camel@edumazet-laptop>
	 <20100604161644.GA98048@trillian.local>
	 <20100606095640.GA4436@trillian.comsick.at>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 12:42:25 +0200
Message-ID: <1275820945.5238.987.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 06 juin 2010 à 11:56 +0200, Michael Guntsche a écrit :
> On 2010.06.04 18:16:44 , Michael Guntsche wrote:
> > I applied the patch recompiled and run it on the routerboard, trying
> > to trigger the bug again.
> 
> Hi Eric,
> 
> Up to now I was not able to reproduce the bug, do you think this patch
> can be pushed to mainline or is there a "better"/other  fix for it?
> 
> Kind regards,
> Michael
> 
> 

Thanks Michael for testing.

I'll submit ASAP an official patch, sent to all people involved in this
driver to get their Ack (or Nack).

IEEE80211_MAX_MPDU_LEN being 3840 + somebits is suspect, since it doesnt
match 802.11 specs.

It should be more close of 2304 + MAC header (32bytes) + FCS (4 bytes) ?



