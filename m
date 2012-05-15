Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab2EOOf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:35:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45149 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab2EOOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:35:25 -0400
Date: Tue, 15 May 2012 15:38:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Andre Hedrick (anhedric)" <anhedric@cisco.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: CFA 4.0 patch
Message-ID: <20120515153818.3e70d845@pyramind.ukuu.org.uk>
In-Reply-To: <4E75C4FECC27A44E9F7E0737D71946900F686C61@xmb-sjc-21e.amer.cisco.com>
References: <4E75C4FECC27A44E9F7E0737D71946900F686C61@xmb-sjc-21e.amer.cisco.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 044Ah: This is the alternate value of Word 0 turns on ATA device and
> turns off Removable Media and Removable Device while 	preserving all
> Retired bits in the word.
> 
> 0040h: This is the alternate value of Word 0 turns on ATA device and
> turns off Removable Media and Removable Device while 	zeroing all
> Retired bits in the word
> 
> Cheers,
> Andre
> --------------------
> The Linux X-ATA/SATA guy
      ^former ;)


> --- linux-2.6.32.orig/include/linux/ata.h	Mon May 14 15:48:24 2012
> +++ linux-2.6.32/include/linux/ata.h	Mon May 14 15:51:42 2012
> @@ -819,6 +819,10 @@
>  {
>  	if (id[ATA_ID_CONFIG] == 0x848A)	/* Traditional CF */
>  		return 1;
> +	if (id[ATA_ID_CONFIG] == 0x044A)	/* Alternative CF w/
> removable turned off, preserving retired bits */
> +		return 1;
> +	if (id[ATA_ID_CONFIG] == 0x0040)	/* Alternative CF w/
> removable turned off, zeroing retired bits*/
> +		return 1;

Do you have test case hardware for this that fails the other checks. I've
never ever come across any. I don't believe it exists at this point.

Also 2.6.32 is some years ago 8)

Alan
