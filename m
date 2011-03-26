Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab1CZMy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 08:54:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55752 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751192Ab1CZMy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 08:54:27 -0400
Date: Sat, 26 Mar 2011 12:54:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: igor@novg.net
Cc: <jgarzik@pobox.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.38.1] pata_it821x: Add module param to force UDMA on
 Vortex86SX
Message-ID: <20110326125441.3e628850@lxorguk.ukuu.org.uk>
In-Reply-To: <89bf4e2c74a16f130208a485c6eafd77@novg.net>
References: <89bf4e2c74a16f130208a485c6eafd77@novg.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  May be there are errors with pure IDE devices or with older revisions 
>  of Vortex86SX
>  boards, i do no know. But for my device i have 2x improvement in I/O 
>  speed when
>  enabling UDMA/33 instead of MWDMA, so i think this parameter would be 
>  useful.

"I do not know" is not a good basis for hacking storage code,
particularly if it was to turn out that the reason was something like
silent data corruption (eg as with UDMA on the old OSB4 controllers in
some cases)

The change came via DMP signoff (the manufacturer) so any adjustment of
this sort of checking really ought to go via DMP as well.

>  Also fix to initialize default value for parameter 'noraid'.

This does not need initialising - C guarantees static variables start at
zero. If that makes a difference you have other problems.

So NAK this.

Although if you want to take it up with DMP and find out if they have
updated rules or checks that want pushing that might be useful.

Alan
