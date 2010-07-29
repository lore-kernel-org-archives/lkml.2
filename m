Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab0G2QB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:01:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60848 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754416Ab0G2QB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 12:01:28 -0400
Date: Thu, 29 Jul 2010 17:13:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, "Michael H. Warfield" <mhw@wittsend.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] char: ip2: check put_user() result
Message-ID: <20100729171300.5ecc0bc2@lxorguk.ukuu.org.uk>
In-Reply-To: <1280418938-5833-1-git-send-email-segooon@gmail.com>
References: <1280418938-5833-1-git-send-email-segooon@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> -	return dumpcount;
> +	return rc ? -EFAULT : dumpcount;

This is actually at least as wrong as before.

The standards say that if you successfully return some data you should
report the bytes returned. Normally it doesn't matter much because the
data has not been 'lost' when it gets called again.

If you actually remove the data from the queue it ought to be getting
reported with a suitable length.

Alan
