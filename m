Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab1C3TZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 15:25:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44859 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932783Ab1C3TZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 15:25:56 -0400
Date: Wed, 30 Mar 2011 20:26:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Palmer <me@danielpalmer.co.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PATA_ARTOP reads byte from PCI IO port without mapping it to
 the right address.
Message-ID: <20110330202628.5dc8db5f@lxorguk.ukuu.org.uk>
In-Reply-To: <4D937FDC.4090607@danielpalmer.co.uk>
References: <4D937FDC.4090607@danielpalmer.co.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> unsigned long io = pci_resource_start(pdev, 4);           // This 
> returns 0x1400 on my machine

That is the PCI port address.

>                  u8 reg;
> 
>                  ppi[0] = &info_628x;
>                  if (inb(io) & 0x10)                                    
>          // This reads from 0x1400, which isn't were the port actually 
> is in the processors address                                             

This reads from I/O port 0x1400 - your inb logic and I/O port mapping on
the platform is responsible for making that work.



