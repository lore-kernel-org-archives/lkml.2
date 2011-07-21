Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1GUQ2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:28:11 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:40960 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752902Ab1GUQ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:28:09 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ioh3_dwVM1nsdS0eD6msaWnzVqs4Y4rcT_fy7XAavYq8hPQ
 roW0A.w1xJIpISy_i2vQ2ymjBsvpx.6EsImuZrTwvZ_db1lPPCKeXNxkvK2o
 eYc7vOguPfzzBl8IMkfHmjGIVwqxrLvTDjjSMUXvFeifBPvJB7SZIkzsPWJZ
 0OpmEIqtFpVX.HCK7EdsKfsdRBES6hdfsE83N8wUpbpZumoLYZ.8tgH3enLz
 CrwU1iTz0CR0.prTAwELoSOVSzQiokeWlE6CF_4vm09vGTcC6Mxn0UwBd4T4
 9iERPEwAi_urCrN8f5YrB.GJ5kfuuz.1RPCuDZem1z2CYnS30E.mMlawJJbr
 HWIehdFyEKoI__gKvZ2jSWdOC
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 21 Jul 2011 11:28:04 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Vasiliy Kulikov <segoon@openwall.com>
cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC v3 2/5] slab: implement slab object boundaries assertion
In-Reply-To: <1311252815-6733-1-git-send-email-segoon@openwall.com>
Message-ID: <alpine.DEB.2.00.1107211127050.3995@router.home>
References: <1311252815-6733-1-git-send-email-segoon@openwall.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011, Vasiliy Kulikov wrote:

> +bool slab_access_ok(const void *ptr, unsigned long len)
> +{
> +	struct page *page;
> +	struct kmem_cache *s = NULL;

Useless assignment.

> +	unsigned long offset;
> +
> +	if (!virt_addr_valid(ptr))
> +		return true;
> +	page = virt_to_head_page(ptr);
> +	if (!PageSlab(page))
> +		return true;
> +
> +	s = page->slab;
> +	offset = (ptr - page_address(page)) % s->size;
> +	if (offset <= s->objsize && len <= s->objsize - offset)
> +		return true;

I thought this was going to be offset < s->objectsize ...?
