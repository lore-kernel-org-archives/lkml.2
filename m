Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1K1V0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:26:09 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57485 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab1K1V0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:26:08 -0500
Date: Mon, 28 Nov 2011 21:27:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stefano Laporta <Stefano.Laporta@bo.infn.it>
Cc: linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: 3.1.3 2.6.37.6 2.6.33.4 kernel bug in pata_oldpiix driver
Message-ID: <20111128212734.7818a2d6@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LNX.2.00.1111281823440.12891@g-3.bo.infn.it>
References: <alpine.LNX.2.00.1111281823440.12891@g-3.bo.infn.it>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> BUG: unable to handle kernel paging request at 45230451

That looks like junk from somewhere.

> IP: [<c17bb1f3>] oldpiix_set_dmamode+0xb3/0x120

>   [<c17bb3b0>] ? oldpiix_qc_issue+0x40/0x60
>   [<c1788d8a>] ? ata_qc_issue+0x1ea/0x330

So we were issuing a command, we called the oldpiix code, it decided that
the timings were not loaded for this drive (ie it was those loaded for
the other device on the bus)

It will then have gone into oldpiix_set_piomode which ran succesfully
implying that ap and adev were valid at that point but seem to have
mysteriously gone invalid later.

No idea, and the fact that changing things like the pre-empt behaviour or
build options makes me wonder if it was scribbled on from elsewhere.


