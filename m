Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab1CQDqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:46:22 -0400
Received: from web37604.mail.mud.yahoo.com ([209.191.87.87]:28594 "HELO
	web37604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751523Ab1CQDqT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:46:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=yvFpQG3Vf753CLeKeRKExxo+vIwBJBGDfpm0xLDikG+wlnoG4OotdB4qGvog8lvx4RJd/jgSJdJRIM/oNAOJkFueRcSMx6+FyQu2ZqeaQfjF6MaC2ASACqMbPnVOBRFE2ZpzhWFns7oOJXLM9w6JRbx7Hl+F9IUFPY3k5xYMUts=;
Message-ID: <722844.29100.qm@web37604.mail.mud.yahoo.com>
X-YMail-OSG: ZKv4rpcVM1kOJ7DlO9.ME3cdvg0jKe2_Azp5GqLOMTpS_Vu
 lh4avRiw2v_WdwwwA0Myl6JGYYtZzC4UMW0zcK5PiAdoiAmJsi1Lp2DD7tUj
 Hn9yxuzwvdp.JtcC4.33fqFO0_0H8PbbDb4Q03bhe2kv_OnIw9M7zdMNsUJC
 gZ8BA.IZxgjmJW6mUVifjmkZM3YIvNviNYbQUAp5K6NSRc4reFHBDbU2oqbS
 l6vFHHp2ycrmShFWHYLaDHb8cxgn9tn1b8NBl3QpX1bokyBK0lhWwyt3FxoY
 sSXaeAGgaEI953whBTA5StjX6uMyIMlmqubEPGuar2FpxUxwkhwPdaS5nhbC
 3qEFZ
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.109.295617
Date: Wed, 16 Mar 2011 20:46:18 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 1/4] scatterlist: new helper functions
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        maximlevitsky@gmail.com, James.Bottomley@HansenPartnership.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110316135528U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Why?
> 
> Why can't the block layer split a request in the way the
> driver wants
> to do?
> 
> That is, why can't the driver tell the block layer how to
> split a
> request?

What is needed is the ability to get fixed sized (in bytes) blocks from 
the block layer.

Last time I checked (it was a long time ago, admittedly) one could only
ask for a fixed number of sg entries, without any control on how many
bytes each sg entry references.

Is there a way to get data from the block layer in a fashion of:
"Give me 16k/32k/whatever in one sg entry if request is equal or larger
than this"?

If my knowledge is correct, MTD currently addresses this issue by
maintaining its own cache, which it uses to aggregate write requests until
it can write a whole erase block. While this is ok with old media
(legacy memory stick being an example of such), new flash chips can
have multi-megabyte sized erase blocks and can benefit from operations
(like copy and compare) directly on scatter list .



      
