Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1B1QsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:48:24 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59759 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1B1QsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:48:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ipe53hjlJiFLJ0r+KJiaxdnT5xJRHK77j/4HSnXZFetVzzPwOFj9qHaMKpnNiFYJc7
         R2f8gkau5+U9UX8aFhiiZM6R/FwccwAtpIbQQnCPo5iuX51opfTwQWYH2yGdwxarRSGO
         R71PM1FWDneo3i90enxaJ5BzSDZlu3T+3Ib90=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Albert Cahalan <acahalan@gmail.com>,
        Mikael Abrahamsson <swmike@swm.pp.se>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <20110228161115.GB2515@tuxdriver.com>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	 <1298793252.8726.45.camel@edumazet-laptop>
	 <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	 <1298837273.8726.128.camel@edumazet-laptop>
	 <20110228161115.GB2515@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 17:48:14 +0100
Message-ID: <1298911694.2941.639.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 28 février 2011 à 11:11 -0500, John W. Linville a écrit :
> On Sun, Feb 27, 2011 at 09:07:53PM +0100, Eric Dumazet wrote:
> 
> > Qdisc should return to caller a good indication packet is queued or
> > dropped at enqueue() time... not later (aka : never)
> > 
> > Accepting a packet at t0, and dropping it later at t0+limit without
> > giving any indication to caller is a problem.
> 
> Can you elaborate on what problem this causes?  Is it any worse than
> if the packet is dropped at some later hop?
> 
> Is there any API that could report the drop to the sender (at
> least a local one) without having to wait for the ack timeout?
> Should there be?
> 

Not all protocols have ACKS ;)

dev_queue_xmit() returns an error code, some callers use it.



