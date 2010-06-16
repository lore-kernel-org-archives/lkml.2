Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab0FPOO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:14:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59959 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758890Ab0FPOOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:14:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OVl9BfyHYAyJ0TXPeKPN322xJdfUwmO1F9uI6+DvJgEK2uDhlLJPn/SVn1ldJZrMYw
         DjY8iUbG5Qr7FQBvNdqZJUWkKwev+CZZVPLpomRyj4AM4ymJ5pcRV00C5+vrxUVrkmlB
         sVyqAZJncrVikE84Fouv42laCFgHE7g2HuCSU=
Subject: Re: [PATCH] Clear IFF_XMIT_DST_RELEASE for teql interfaces
From: Eric Dumazet <eric.dumazet@gmail.com>
To: hadi@cyberus.ca
Cc: Tom Hughes <tom@compton.nu>, netdev@vger.kernel.org,
       akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1276694745.3862.1.camel@bigi>
References: <1276676668-10256-1-git-send-email-tom@compton.nu>
	 <1276694745.3862.1.camel@bigi>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 16:14:20 +0200
Message-ID: <1276697660.2632.79.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 16 juin 2010 à 09:25 -0400, jamal a écrit :
> On Wed, 2010-06-16 at 09:24 +0100, Tom Hughes wrote:
> > The sch_teql module, which can be used to load balance over a set of
> > underlying interfaces, stopped working after 2.6.30 and has been
> > broken in all kernels since then for any underlying interface which
> > requires the addition of link level headers.
> > 
> > The problem is that the transmit routine relies on being able to
> > access the destination address in the skb in order to do address
> > resolution once it has decided which underlying interface it is going
> > to transmit through.
> > 
> > In 2.6.31 the IFF_XMIT_DST_RELEASE flag was introduced, and set by
> > default for all interfaces, which causes the destination address to be
> > released before the transmit routine for the interface is called.
> > 
> > The solution is to clear that flag for teql interfaces.
> > 
> > Signed-off-by: Tom Hughes <tom@compton.nu>
> 
> Sounds reasonable. Lets CC Eric and get his ACK.
> 
> cheers,
> jamal
> 

Sure, I already Acked in on a previous message 5 days ago (although not
a formal patch, Stephen forwarded a bugzilla entry)

http://permalink.gmane.org/gmane.linux.network/163688

Please David, could you add bugzilla entry in commit ?

https://bugzilla.kernel.org/show_bug.cgi?id=16183

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Thanks !


