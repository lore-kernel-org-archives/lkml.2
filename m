Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2HNOs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 10:48:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45669 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2HNOsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 10:48:22 -0400
Date: Tue, 14 Aug 2012 15:52:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Alan Cox <alan@linux.intel.com>, Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Powerpc 8xx CPM_UART delay in receive
Message-ID: <20120814155227.018988da@pyramind.ukuu.org.uk>
In-Reply-To: <201208141426.q7EEQSPc003956@localhost.localdomain>
References: <201208141426.q7EEQSPc003956@localhost.localdomain>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2012 16:26:28 +0200
Christophe Leroy <christophe.leroy@c-s.fr> wrote:

> Hello,
> 
> I'm not sure who to address this Patch to either
> 
> It fixes a delay issue with CPM UART driver on Powerpc MPC8xx.
> The problem is that with the actual code, the driver waits 32 IDLE patterns before returning the received data to the upper level. It means for instance about 1 second at 300 bauds.
> This fix limits to one byte the waiting period.

Take a look how the 8250 does it - I think you want to set the value
based upon the data rate. Your patch will break it for everyone doing
high seed I/O.

Alan
