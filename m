Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085Ab0GBQLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:11:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:51767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967Ab0GBQLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:11:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] arch/tile: Add driver to enable access to the user dynamic network.
Date: Fri, 2 Jul 2010 18:11:03 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <201006252110.o5PLArvw010770@farm-0002.internal.tilera.com> <201006282134.55166.arnd@arndb.de> <4C2DD958.7030005@tilera.com>
In-Reply-To: <4C2DD958.7030005@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201007021811.04197.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX188sUev5/xx+yACuH9dYxKMtDn8gDAS+OiaDXe
 kc5YVQu3xAg9EH01kEhLcw0GbELnLAFPMB6PTWbp0v77a9r92p
 9s+MN10IfmxT/tNdFVsUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010, Chris Metcalf wrote:
> So, if there's a good reason for it to be there, I'd say that pushes us
> back toward a separate <linux/list_types.h>.  Otherwise we can
> investigate splitting out the prefetch content on every platform to
> <asm/prefetch.h> (presumably creating some empty <asm/prefetch.h>
> headers on architectures that just use the gcc builtin) and adding new
> #includes of <asm/prefetch.h> to files that reference the prefetch
> functionality.  Arnd and other list folks, what's your instinct?

Makes sense. Splitting out the list types from list.h does seem to be
safest option. We might actually be able to do some header file
untangling that way, by using list_types.h in all headers that
use a list_head by none of the macros and functions associated with it.

	Arnd
