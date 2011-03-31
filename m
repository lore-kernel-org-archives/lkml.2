Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab1CaOtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:49:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab1CaOth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:49:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Thu, 31 Mar 2011 16:49:21 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: sameo@linux.intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, alan@lxorguk.ukuu.org.uk,
        Sebastian.Chlad@tieto.com
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <20110331141650.GB2704@sortiz-mobl> <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481085F0FE5A@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311649.21737.arnd@arndb.de>
X-Provags-ID: V02:K0:a3EzR8ARJqDfoIOapqJDveCYzGwrP27RduWl6eayaCr
 CpCSnLlHP04EXh/0iA1jYvm4XFXPyYC/0TJTWJObgi5+NNAgnx
 XwK7T6E78GRqd690O3hIObutYf2gFr2nuWeDal41aD+/SjCPO7
 8pa/a0ID6YENXrQ/thXVrMV0WRS84glIxcXRCA/4NeGcG8wpL2
 gjK7IL5DRqqx/1dwwlo1A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >My idea of an initial NFC subsystem architecture was actually 
> >the following
> >one:
> >- A core NFC layer against which NFC drivers would register.
> >- A netlink socket for handling the HCI commands. That would 
> >put a big part of the NFC HCI layer in kernel land and could 
> >potentially simplify the existing NFC stacks.
> 
> Shouldn't be better to add a new AF_NFC sock family and then
> register new LLCP and HCI protocols?

That depends on what the HCI protocol really looks like, e.g.
is it's related to the LLCP data at all or not.

Another option might be to control the HCI over setsockopts,
but the netlink socket sounds more flexible for this.

	Arnd
