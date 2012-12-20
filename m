Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2LTNBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 08:01:04 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55168 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2LTNA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 08:00:56 -0500
Date: Thu, 20 Dec 2012 13:06:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Xiao, Jin" <jin.xiao@intel.com>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "Douglas, William" <william.douglas@intel.com>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "Pillet, VincentX" <vincentx.pillet@intel.com>
Subject: Re: [PATCH] n_gsm.c: add tx_lock in gsm_send
Message-ID: <20121220130626.6b4aea39@pyramind.ukuu.org.uk>
In-Reply-To: <375E373B4157DC49B89CEAE588F836F50FE455C5@SHSMSX102.ccr.corp.intel.com>
References: <1355963920.9600.99.camel@xiaojin>
	<20121220114411.4dcc81bb@pyramind.ukuu.org.uk>
	<375E373B4157DC49B89CEAE588F836F50FE455C5@SHSMSX102.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2012 12:13:07 +0000
"Xiao, Jin" <jin.xiao@intel.com> wrote:

> Alan, 
> 
> Thanks. But the comment makes me confused. As we see, gsm->output is called by gsm_data_kick too, and it's in the tx_lock...

That would be a bug too or I guess we could finally give in on trying to
keep tty write paths not using spin_lock_irq and fix any oddments that
blow up. That might actually be the right thing to do as its caused
problems in other places too, and the USB tty drivers are now well
behaved.

Your patch doesn't make it any worse however so I agree it might as well
go in.

Alan


