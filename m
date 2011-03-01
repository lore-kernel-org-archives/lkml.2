Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810Ab1CAFBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:01:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47122 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1CAFB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:01:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Pw8gewaAs2OzoDyzpHVsa6MH4RnEmVwYHA73eZF3P6ACJjw74IAlPRpyHu2vbdpM8y
         pa+EfOX8pc95Jw44143hHfHBnbKT2Ujcr+/Rdinf6Nc63VYeIlfKj6bjUbEdfbSqrPUM
         Z3KnY26aDsbTLiV1XrNJrjKhXOTvSSsfKl5Lk=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: John Heffner <johnwheffner@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 06:01:23 +0100
Message-ID: <1298955683.2676.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 février 2011 à 23:11 -0500, Albert Cahalan a écrit :

> It sounds like you need a callback or similar, so that TCP can be
> informed later that the drop has occurred.

There is the thing called skb destructor / skb_orphan() mess, that is
not stackable... Might extend this to something more clever, and be able
to call functions (into TCP stack for example) giving a status of skb :
Sent, or dropped somewhere in the stack...



