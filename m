Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab1FGSbi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:31:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42742 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab1FGSbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:31:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k0kIgAd5X9hx+RZl3kN0QtDKEB3YbF9/bMiLsNkgvWXWswTta/UWrSyPESfX/7oNff
         UZ3JaCpRlgUdz2DCIDJx9nwRv+4ndGKaM0cCy9FzBjseHb/m727+ClDFofjp2Sb0AJCs
         PD0loe6aYg3hgM2pPo31jbAvxgUcDo/TMm+fs=
Subject: Re: KVM induced panic on 2.6.38[2367] & 2.6.39
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Brad Campbell <brad@fnarfbargle.com>,
        Bart De Schuymer <bdschuym@pandora.be>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
In-Reply-To: <4DEE4538.1020404@trash.net>
References: <20110601011527.GN19505@random.random>
	 <alpine.LSU.2.00.1105312120530.22808@sister.anvils>
	 <4DE5DCA8.7070704@fnarfbargle.com> <4DE5E29E.7080009@redhat.com>
	 <4DE60669.9050606@fnarfbargle.com> <4DE60918.3010008@redhat.com>
	 <4DE60940.1070107@redhat.com> <4DE61A2B.7000008@fnarfbargle.com>
	 <20110601111841.GB3956@zip.com.au> <4DE62801.9080804@fnarfbargle.com>
	 <20110601230342.GC3956@zip.com.au> <4DE8E3ED.7080004@fnarfbargle.com>
	 <isavsg$3or$1@dough.gmane.org> <4DE906C0.6060901@fnarfbargle.com>
	 <4DED344D.7000005@pandora.be> <4DED9C23.2030408@fnarfbargle.com>
	 <4DEE27DE.7060004@trash.net> <4DEE3859.6070808@fnarfbargle.com>
	 <4DEE4538.1020404@trash.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 20:31:24 +0200
Message-ID: <1307471484.3091.43.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 07 juin 2011 à 17:35 +0200, Patrick McHardy a écrit :

> The main suspects would be NAT and TCPMSS. Did you also try whether
> the crash occurs with only one of these these rules?
> 
> > I've just compiled out CONFIG_BRIDGE_NETFILTER and can no longer access
> > the address the way I was doing it, so that's a no-go for me.
> 
> That's really weird since you're apparently not using any bridge
> netfilter features. It shouldn't have any effect besides changing
> at which point ip_tables is invoked. How are your network devices
> configured (specifically any bridges)?

Something in the kernel does 

u16 *ptr = addr (given by kmalloc())

ptr[-1] = 0;

Could be an off-one error in a memmove()/memcopy() or loop...

I cant see a network issue here.

I checked arch/x86/lib/memmove_64.S and it seems fine.



