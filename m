Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab0DFFnt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:43:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:51721 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0DFFnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:43:45 -0400
Subject: Re: mprotect pgprot handling weirdness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1270530566.13812.28.camel@pasglop>
References: <1270530566.13812.28.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 15:43:42 +1000
Message-ID: <1270532622.13812.30.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 15:09 +1000, Benjamin Herrenschmidt wrote:
> (*) Right now it's near impossible to add arch specific PROT_* bits to
> mmap/mprotect for fancy things like cachability attributes, or other
> nifty things like reverse-endian mappings that we have on some embedded
> platforms, I'm investigating ways to better separate vm_page_prot from
> vm_flags so some PROT_* bits can go straight to the former without
> having to be mirrored in some way in the later.

The other (easier) option is to make the vm flags always 64-bit and
reserve a range of bits here for the arch to use but I suppose there's
going to be unhappiness about that one :-)

Cheers,
Ben.


