Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2LTM4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:56:40 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55153 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab2LTM43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:56:29 -0500
Date: Thu, 20 Dec 2012 13:01:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Shut up annoying native_sectors warning
Message-ID: <20121220130159.7125e700@pyramind.ukuu.org.uk>
In-Reply-To: <1356006355-6819-1-git-send-email-bp@alien8.de>
References: <1356006355-6819-1-git-send-email-bp@alien8.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 13:25:55 +0100
Borislav Petkov <bp@alien8.de> wrote:

> I'm getting this
> 
> drivers/ata/libata-core.c: In function ‘ata_hpa_resize’:
> drivers/ata/libata-core.c:1397:3: warning: ‘native_sectors’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> for a couple of kernel releases now with gcc (Debian 4.7.2-4) 4.7.2.
> 
> And the warning is bogus because ata_read_native_max_address either
> returns a sensible max_sectors aka native_sectors through its second
> arg pointer or an error value which is properly handled in its caller
> ata_hpa_resize().
> 
> So shut up gcc already.

And ensure it won't be noticed if a real problem is found. So we go from
warning for a few people who ignore it, to silence for everyone if a real
bug appears

Net lose IMHO - better to file a gcc bug report

Alan

