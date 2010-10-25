Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0JYPB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:01:29 -0400
Received: from web37607.mail.mud.yahoo.com ([209.191.87.90]:44402 "HELO
	web37607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754903Ab0JYPB2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:01:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=r7eHHzB9o4a+iQZ6FsIKoVKEPAowbt10pqqqUcfF+NfH4as9fgG40jluimyjG40PNptnydlAlH2bPvrmzrQ9bWsuoIpnXxjeiUWVeNUHNrLRDoRSS+Z9O+iAytekr5ZZIcnQRMK7uJEVSP4sdeJYBdEzs1xsLG5ULAOm1J0/AWA=;
Message-ID: <381457.73980.qm@web37607.mail.mud.yahoo.com>
X-YMail-OSG: AESPXwIVM1m_OJdiBQNiRrzGTqepLgoUYIy5rmeGVGe8FF8
 bxb_7yJYZhC3FGlc5U8Mkgwowg8c6DYWDn2VmeqEovobTk5hzCBsQvwxg8cT
 gnPufKl4qdKL7jLA72eM1JvuzeizYPA2KDAfKfG39qjEruauVyGWWL1z5aak
 avm63UFCohimTgKCxhEzYmI2L3GoSdfTwZ622OPXmBb14Blafgt4ijvOojQn
 MAZ0pJkiUHPu4LjznWDN7zOFlaDDwEXPwCcVHKpb3zWHzz2lUZjGZeOJChh_
 6t3JDBPaUFmkT5q7VJw.HvD8S7xwZsXOY1oVzhtc7eRKF8eIcUkKdED1JYzY
 NR2.SGqqaLbt7TUtZ_.1lCSCDJfUQaVhjXU.YF.oxQf_tniN6
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Mon, 25 Oct 2010 08:01:26 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 04/29] memstick: core: rework state machines
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <1287791637-10329-5-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> From: Maxim Levitsky <maximlevitsky@gmail.com>
> Subject: [PATCH 04/29] memstick: core: rework state machines
> To: "Alex Dubov" <oakad@yahoo.com>
> Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> Received: Friday, 22 October, 2010, 4:53 PM
> Make state machines in memstick core
> follow the
> new style.
> 

1. This is an important functional patch. At present, "new style" exists
only in your head. You should make an effort to justify it to everybody
else by providing a rationale in patch description.

2. You are using an integer state variable (instead of function pointers
which were self-describing by virtue of the referred function names).
Please, define an enumerated type for this state variable, giving states
human-readable, descriptive names. If you need to do state variable
arithmetic, you can provide a couple of simple, descriptive macros to
do so:

#define NEXT_STATE(s) (s + 1)

or something along the line.

3. Coding style.



      
