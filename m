Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab0FPNZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 09:25:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36579 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0FPNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 09:25:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=xsfuHJZ0iNULDdr2a7Uj22KC1UBQvN4DdRXDEphV7Mlt7/dOg4CU2QRV4n8gHYrt5t
         5aFFf/LiS3/Px4l8zaKHWrqpEgVa2BT/9z4/35BsulzYYJyj3o9xh6qnSae/uv+/44Mp
         7iQVGBTUurUju0OE6S/lsvF32/TgqCAdsaXR8=
Subject: Re: [PATCH] Clear IFF_XMIT_DST_RELEASE for teql interfaces
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Tom Hughes <tom@compton.nu>
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276676668-10256-1-git-send-email-tom@compton.nu>
References: <1276676668-10256-1-git-send-email-tom@compton.nu>
Content-Type: text/plain
Date: Wed, 16 Jun 2010 09:25:45 -0400
Message-Id: <1276694745.3862.1.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 09:24 +0100, Tom Hughes wrote:
> The sch_teql module, which can be used to load balance over a set of
> underlying interfaces, stopped working after 2.6.30 and has been
> broken in all kernels since then for any underlying interface which
> requires the addition of link level headers.
> 
> The problem is that the transmit routine relies on being able to
> access the destination address in the skb in order to do address
> resolution once it has decided which underlying interface it is going
> to transmit through.
> 
> In 2.6.31 the IFF_XMIT_DST_RELEASE flag was introduced, and set by
> default for all interfaces, which causes the destination address to be
> released before the transmit routine for the interface is called.
> 
> The solution is to clear that flag for teql interfaces.
> 
> Signed-off-by: Tom Hughes <tom@compton.nu>

Sounds reasonable. Lets CC Eric and get his ACK.

cheers,
jamal

