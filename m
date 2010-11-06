Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0KFTIC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 15:08:02 -0400
Received: from nm5.bullet.mail.sp2.yahoo.com ([98.139.91.75]:34353 "HELO
	nm5.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753128Ab0KFTH7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 15:07:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 843643.61933.bm@omp1017.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Ooqt0DdeNNb6Nwf44HSvICHZbq0R29nmPdYORjdeIAL3fzgOjp27XCJdN+ya0JqmtNMU+zG9YeDkKZANdgBVK2JhuTuKVdaGvnB4tqzAvqgVbB1gBlgKTYkP8Qq+aPCZP/mWjxsSsJZAaSzp45+Yj5S/BjbPJrx4WU5JubF1Vjk=;
Message-ID: <305211.72066.qm@web180314.mail.gq1.yahoo.com>
X-YMail-OSG: FX5s2PEVM1lTjcLnFfH0T1eJe3utt7D.sg8KPFLAcTBCjC2
 iTPHjc5eck0MNRo9DtIAr_sUiaL0bZOn.HeiFIdGNRLR0xpJSih2CbKXf56Z
 ziGyVg816rJ1qBj3HZfqYvSPUHYyUf2B.clOH72wd9TrjGkpVHJi7wY6e697
 BHHf0nXdbayMXENVmI_rPadOLqYmrbIuFOX62GQT9BYJ6HCa_JxEvSuqPkEQ
 dR6KPpZtV2GmNl705pJFTxM3uaREBnphjD4ixgAS46kgc77wDGeZ_EY78YW3
 SIJCHpRljDU7b6vWByUA037xwVvdtrzdTiwZls9TXXBQjpJTyM6lKa.Tg32g
 TCSsWB9hXKddKG3uQ9lSh_B.1bRMBO7eWAlg3cus-
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Sat, 6 Nov 2010 12:07:57 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] usb: core: fix information leak to userland
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Vasiliy Kulikov <segooon@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
        Andi Kleen <ak@linux.intel.com>, Chris Frey <cdfrey@foursquare.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.1011061441150.28403-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 11/6/10, Alan Stern <stern@rowland.harvard.edu> wrote:


> > 
> 
> Unfortunately I don't have a copy of the C standard here to
> consult.  
> However...  Although I'm perfectly willing to believe
> that the standard
> requires fields in a structure to be initialized to 0 if
> they
> aren't mentioned explicitly in the initializer, I'm
> considerably more
> doubtful that it also requires padding to be initialized!

ISTR initialization-to-zero is the standard
behavior defined for all _memory_ that gets
initialized ... not just named fields ...
whether the init is "static", "bss", or not.
> 
> And I certainly wouldn't want to depend on compilers
> _always_ using 
> memset to do this initialization.

Of course not; just rely on init-to-zero, and
let the compiler worry about efficiency. In
some cases memset(); in others, the result
might be as if memset were inlined, so only
a few "write a zero at this address" type
instructions would be needed.
> 
> > There's certainly a fair amount of code I've seen
> > that uses runtime initializers like that, to zero
> > memory.  I can't believe i's _all_ broken! 
> ;)
> 
> Zeroing memory that belongs to a declared field is
> different from 
> zeroing padding bytes.  Maybe what you remember seeing
> is the first and 
> not the second.

I remember seeing both, and at one point looking
at the issue to verify that padding was treated
uniformly (like other memory).  Also, writing code
that relied on zero-initted padding.

- Dave

