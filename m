Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2JKN3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:29:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35833 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2JKN3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:29:02 -0400
Date: Thu, 11 Oct 2012 14:34:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: James Hogan <james.hogan@imgtec.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Message-ID: <20121011143400.49f79a7f@pyramind.ukuu.org.uk>
In-Reply-To: <1349960296.2425.53.camel@dabdike.int.hansenpartnership.com>
References: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>
	<1349951069.2425.44.camel@dabdike.int.hansenpartnership.com>
	<5076AE3B.5040509@imgtec.com>
	<1349960296.2425.53.camel@dabdike.int.hansenpartnership.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The alignment is fine (the offset of the u16 is 8 bytes), but
> > unfortunately with the metag port of gcc, sizeof(struct
> > scsi_varlen_cdb_hdr) is rounded up to a 4 byte boundary (even though the
> > largest data member alignment is only 2 bytes), which is 12 bytes
> > instead of 10.
> 
> That sounds to be a bug in your compiler ... it shouldn't be rounding up
> structure sizes if the structure can fit in 10 bytes.  This isn't
> happening in any other architecture that I know of (otherwise we'd have
> had a reported build break).

It's not a bug for the alignment rules of the processor as far as I can
see. The architectural definition is perfectly entitled to have tail
padding in this case.

The x86 equivalent would be

struct foo {
	double x;
	int a;
};


which is *NOT* 12 bytes long.

It is indeed a portability bug in the scsi layer.

Alan
