Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab1D0OGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:06:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41968 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab1D0OGl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:06:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Vieshgy48o17Iv8GN4opRLkpmORTpNJDKqubNh2dTCcq9xz7Y6lBOHVfSMbD1MOb3i
         7a7goRq+27sSKNfrQdNLlMX/mURgq0pZ/zdvbYxjXw1FS9HFpG90jhO8BVGsBsxhTlzm
         IpmhD08E3B5OJIMv4FKC8/fCjAjvUKwte/vzU=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1104261447481.2035-100000@iolanthe.rowland.org>
References: <BANLkTi=-DFfdiBKZzRBxF-yMJFtWnzuk1g@mail.gmail.com> <Pine.LNX.4.44L0.1104261447481.2035-100000@iolanthe.rowland.org>
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 27 Apr 2011 19:36:00 +0530
X-Google-Sender-Auth: seCQdnrQA7Hs7JFY_pDnCAhwpY8
Message-ID: <BANLkTimxLjvq2GC8_TJJk9OXZ9fPc-JKiA@mail.gmail.com>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        Peter Maydell <peter.maydell@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 00:21, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 26 Apr 2011, Rabin Vincent wrote:
>> In my case it's this writel() in ehci-hub.c that gets chopped into
>> strbs:
>>
>>       /* force reset to complete */
>>       ehci_writel(ehci, temp & ~(PORT_RWC_BITS | PORT_RESET),
>>                               status_reg);
>
> Why would that get messed up?  The status_reg variable doesn't have any
> __atribute__((packed)) associated with it.

The initialization of status_reg is:

	u32 __iomem *status_reg
		= &ehci->regs->port_status[(wIndex & 0xff) - 1];

where ehci->regs is a pointer to the packed struct ehci_regs.  So, this
is the same problem of casting pointers to stricter alignment.
