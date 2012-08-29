Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab2H2Ivs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 04:51:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38957 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2H2Ivr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 04:51:47 -0400
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "H.K. Jerry Chu" <hkjerry.chu@gmail.com>
Cc: Alexander Bergmann <alex@linlab.net>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CAFbMe2Pgjbttt+Z3RQ9KL05=GHqZYk5ubNH2G1-EUn_f_RBaEQ@mail.gmail.com>
References: <1345724123.5904.756.camel@edumazet-glaptop>
	 <50362407.9070805@linlab.net> <1345726185.5904.835.camel@edumazet-glaptop>
	 <20120824.134231.41073001349178209.davem@davemloft.net>
	 <20120825084819.GD430@linlab.net>
	 <CAFbMe2Pgjbttt+Z3RQ9KL05=GHqZYk5ubNH2G1-EUn_f_RBaEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Aug 2012 01:51:45 -0700
Message-ID: <1346230305.2522.15.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-28 at 21:34 -0700, H.K. Jerry Chu wrote:

> IMHO 31secs seem a little short. Why not change it to 6 as well because 63
> secs still beats 93secs with 3sec initRTO and 5 retries.
> 
> Jerry
> 

My rationale was that such increase were going to amplify SYN attacks
impact by 20% (if we count number of useless SYNACK sent)

If the active side sends SYN packets for 180 seconds, do we really want
to also send SYNACKS for additional 100 seconds ?

Sure, RFC numbers are what they are, but in practice, I doubt someone
will really miss the extra SYNACK sent after ~32 seconds, since it would
matter only for the last SYN attempted.



