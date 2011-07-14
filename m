Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab1GNFG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 01:06:58 -0400
Received: from nm15-vm0.bullet.mail.ird.yahoo.com ([77.238.189.216]:32680 "HELO
	nm15-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753282Ab1GNFG4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 01:06:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 984965.44226.bm@omp1013.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=t/2Dgh7eC8BQBrtvr+spcg5GaKQhyyNQkoMY+AvfoV1IjE1YtZUnnVMAQPQHP+fBt3WwyAzAub9xkXctlusUKgnoIBg6g/BHgC5KPo/psEGP7fWHhqWdSCWLmXnyxe+gP3IgedlphnoOvqPsFoTNAGtU4k/ZoIP+/GRXSxT3eXY=;
X-YMail-OSG: Nnj2.LMVM1k_dpORaX4_4iYK061yLE_DFQg7JL8qiK4bQCm
 iLcFIYdHucB3BlnQfTB5iumMIAhAjbWOjHZPbhRqoVabthuPEK1gkrjs3GA1
 r3MzJlePOho53p2uFU5J.h7y32lx80Kn_1tWqyLCulIiwzX8t3l8_krkOtKO
 cJeAm4jhI4iz9zWyd8nVie4Wj9McDJpZZ5tMZ6kEEYrBcXyx.SP8VDtvmP47
 VbT1IUHmScoH4nze8t608yan4ziFelDM5XVJoJo4JGerC2wNnPxcWz.PmRB7
 a1iUDVnPsBhiDEBv9rZxNKA9vSA4zSJ.NGHPkDUEJ2zyun5zP_oH8lygCBy3
 5EPVEccYi5UGOgXXYrg--
X-Mailer: YahooMailClassic/14.0.3 YahooMailWebService/0.8.112.307740
Message-ID: <1310620014.9822.YahooMailClassic@web29502.mail.ird.yahoo.com>
Date: Thu, 14 Jul 2011 06:06:54 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: [PATCH] hfsplus: Add record offset check
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Naohiro Aota <naota@elisp.net>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@tuxera.com>
In-Reply-To: <CAOJsxLHi_5yuqvOEoGuGQbz86TTuMpinbHzuNEtmvZaZMhcJYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 13/7/11, Pekka Enberg <penberg@kernel.org> wrote:

> From: Pekka Enberg <penberg@kernel.org>
> Subject: Re: [PATCH] hfsplus: Add record offset check
> To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
> Cc: linux-fsdevel@vger.kernel.org, "Naohiro Aota" <naota@elisp.net>, linux-kernel@vger.kernel.org, "Christoph Hellwig" <hch@tuxera.com>
> Date: Wednesday, 13 July, 2011, 7:06
> On Wed, Jul 13, 2011 at 6:58 AM,
> Hin-Tak Leung <hintak_leung@yahoo.co.uk>
> wrote:
> >> Corrupted disk may return record offset which is
> larger
> >> than node size
> >> and cause general protection fault like below:
> >
> > <snipped>
> >
> >> This patch add guard for this situation.
> >>
> >> Signed-off-by: Naohiro Aota <naota@elisp.net>
> >
> > Nacked. This isn't acceptable. Explained above.
> 
> 'recoff' is read from disk which can be easily fuzzed to
> have an
> offset that's larger than node_size, no? The kernel
> shouldn't oops in
> that cases so what's the problem with the patch? (The
> changelog is
> terribly vague, though, and needs to be fixed).

You have put your finger one problem of the patch - 'The changelog is terribly vague, though, and needs to be fixed'.

The other issue is that, while the kernel should not oops no matter what, the patch (or the changelog itself) made no attempts at explaining why this specific approach. e.g. What happens after 'return 0'? For example.





