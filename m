Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2C0NaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 09:30:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47151 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2C0NaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 09:30:22 -0400
Date: Tue, 27 Mar 2012 14:32:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wang YanQing <udknight@gmail.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, spock@gentoo.org
Subject: Re: [PATCH] video:uvesafb: Fix oops that uvesafb try to execute
 NX-protected page
Message-ID: <20120327143243.015ecff6@pyramind.ukuu.org.uk>
In-Reply-To: <20120327100136.GA3829@udknight>
References: <20120327100136.GA3829@udknight>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012 18:01:36 +0800
Wang YanQing <udknight@gmail.com> wrote:

> 
> Ok! I try to check pcibios_enabled first, but get some opposition by Alan Cox,
> but I want to make thing work and fix the oops, so I choice the simple way to
> check the (__supported_pte_mask & _PAGE_NX) instead of to check this variable plus
> pci kernel boot parameter, pci mmconfig works or not, and more, and more. It is not
> the best method, but it works and maybe all will feel happy.

Okay let me ask the obvious question - why is it not the best method ?

Apart from adding a helper in the includes for the arch code of

	static inline is_nx_enabled(void)
	{
		return !!(__supported_pte_mask & _PAGE_NX);
	}

is there anything else it lacks ?

Yes ideally we'd set the relevant ROM areas executable, but for a simple
fix is there anything else that's a problem with it ?

Alan
