Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0CZP6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 11:58:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50628 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751473Ab0CZP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 11:58:29 -0400
Date: Fri, 26 Mar 2010 16:02:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP
 multi-link
Message-ID: <20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
In-Reply-To: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We are fully aware that this code is not nearly up for inclusion into
> the kernel. What we hope to achieve is that someone with the skills to
> do this properly will introduce an option to turn off fragmentation on
> PPP multi-link or to just do away with it completely.

You should be able to manage that I'm sure:

The main thing will be to take this chunk, strip out the // stuff and
then make it a function of its own so you've got clean code in the main
path of the form

#ifdef CONFIG_PPP_MULTILINK
	if (ml_explode) {
		if (!ppp_mp_explode(...)
	..
	} else {
		ppp_mp_roundrobin(...)
	}

and your bits as a new routine. You can then do this

static int ml_explode = 1;
module_param(ml_explode, int, 0600);
MODULE_PARM_DESC(ml_expode, "Set this to zero to disabling multilink \
	fragmentation when talking to cisco devices");

which will let you load the module with the option ml_explode = 0 if you
want that property.

Making it runtime per link selectable would be nicer but thats a bit more
work.

Alan

