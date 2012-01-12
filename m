Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab2ALJWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 04:22:09 -0500
Received: from mail4.comsite.net ([205.238.176.238]:7319 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab2ALJWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 04:22:07 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Denis Turischev <denis@compulab.co.il>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio/it8761e: Restrict it8761e gpio driver to x86.
In-Reply-To: <1326309371-10757-1-git-send-email-grant.likely@secretlab.ca>
References: <1326309371-10757-1-git-send-email-grant.likely@secretlab.ca>
Message-Id: <document-depends-on-reason@mdm.bga.com>
Date: Thu, 12 Jan 2012 03:22:05 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed Jan 11 2012 - 14:16:36 EST, Grant Likely wrote:
> This driver does an unconditional read of io space during module init which
> causes a bad dereference on ARM. It looks to me like this is an x86 only
> drivers, so restrict it to only compile on x86.

> config GPIO_IT8761E
>          tristate "IT8761E GPIO support"
> +        depends on X86
>          help
>            Say yes here to support GPIO functionality of IT8761E super I/O chip.


Please add a comment to the Kconfig stanza with the reason for the
dependancy so people don't have to be git blame masters to know why
its there.

Something like
        depends on X86 # unconditional read of io space during module init

thanks,
milton
