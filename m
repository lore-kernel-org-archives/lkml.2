Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2IRSn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:43:29 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35192 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2IRSn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:43:27 -0400
Date: Tue, 18 Sep 2012 19:48:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: sjur.brandeland@stericsson.com
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
        Sjur =?UTF-8?B?QnLDpm5kZWxhbmQ=?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [RFCv2] remoteproc: Add STE modem driver for remoteproc
Message-ID: <20120918194819.08538bed@pyramind.ukuu.org.uk>
In-Reply-To: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1347992952-4134-1-git-send-email-sjur.brandeland@stericsson.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> +	/* make sure the offsets array isn't truncated */
> +	if (table->num * sizeof(table->offset[0]) +
> +	    sizeof(struct resource_table) > entry->size) {
> +		sproc_err(sproc, "resource table incomplete\n");
> +		return NULL;

None of these checks appear to be robust against maths overflow. So the
question I'd ask is how far do you trust your inputs ?

Alan
