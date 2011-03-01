Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1CAFhG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:37:06 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38772 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab1CAFhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xjwg1OxbR5RcS+vaP3zbehfR3VPwXkTVBkIoX8E/cxaxfs/lYF14sQ/wn35STiLfPW
         IcrPPSGr1e3k6nfsNipiBlb6LQhY2ML3Mct1cORhCcWF+NnWCMkIhy8T3jAlVuAYqQRB
         Bt7XhZywF5UGniMtJwzl7BZeRwg6if6imGH/k=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: John Heffner <johnwheffner@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <1298955683.2676.2.camel@edumazet-laptop>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	 <1298793252.8726.45.camel@edumazet-laptop>
	 <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	 <1298837273.8726.128.camel@edumazet-laptop>
	 <20110228161115.GB2515@tuxdriver.com>
	 <1298911694.2941.639.camel@edumazet-laptop>
	 <20110228165501.GC2515@tuxdriver.com>
	 <AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
	 <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
	 <1298955683.2676.2.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 06:36:58 +0100
Message-ID: <1298957818.2676.15.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 06:01 +0100, Eric Dumazet a écrit :
> Le lundi 28 février 2011 à 23:11 -0500, Albert Cahalan a écrit :
> 
> > It sounds like you need a callback or similar, so that TCP can be
> > informed later that the drop has occurred.
> 
> There is the thing called skb destructor / skb_orphan() mess, that is
> not stackable... Might extend this to something more clever, and be able
> to call functions (into TCP stack for example) giving a status of skb :
> Sent, or dropped somewhere in the stack...
> 

One problem of such schem is the huge extra cost involved, extra
locking, extra memory allocations, extra atomic operations...



