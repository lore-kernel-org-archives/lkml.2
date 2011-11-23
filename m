Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1KWKn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:43:27 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39662 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076Ab1KWKnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:43:25 -0500
Date: Wed, 23 Nov 2011 10:44:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Joerg Reuter <jreuter@yaina.de>,
        Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] ax25: integer overflows in ax25_setsockopt()
Message-ID: <20111123104449.5e845a0f@lxorguk.ukuu.org.uk>
In-Reply-To: <7187C142-99F1-4A96-9BE6-650B10C9B22D@gmail.com>
References: <7187C142-99F1-4A96-9BE6-650B10C9B22D@gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	case AX25_T1:
> -		if (opt < 1) {
> +		if (opt < 1 || opt > 30) {

Where do these values come from ? If they are from some 'standard' then
really we should avoid restricting needlessly to it, particularly as
AX.25 isn't well defined and is used for all sorts of crazy stuff where
the usual range of settings isn't useful.

Restricting to the point it would overflow makes sense however.

Alan

