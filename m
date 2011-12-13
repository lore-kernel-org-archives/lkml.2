Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1LMQPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 11:15:31 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:39016 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752728Ab1LMQPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 11:15:30 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bNpOsVEVM1larmFQ49_q3.EZTovjv_eW2p161m0mW5kCFqN
 DjWYmgxbkfdW7AZo32nXwqUHrgeOzHmfR7oiwv8itp4YVj0qVaoA2Lvq8YM8
 lbM21_h87sFbBlaMqTM37WBHsWUIRs4xPQuRTq6p9MhYrkwJJ2E5WwbkugBp
 EeQbsIPauDln1i6D_HXUb1qrZvrLcTJsCkOgHRKULpfORXzTNaET1N3KsI_o
 uVyVbSn2aZhZwBzpPqV8tmfx17pcSDWiGfFZ8fiXEKbVaj9XWpHNqXNij_Qq
 x3LYtfXMktyW3OO8fPeSupuL9_CmpAxljkm5tvKv.hvkPIpdCUDmSOs7PUw1
 2HtkWW_HmX4qq6E48PIZvY2PfdZ.KjhTXkK1fGOwfGIyqaQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 13 Dec 2011 10:15:27 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: roel <roel.kluin@gmail.com>
cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: slab: too much allocated in bootstrap head arrays?
In-Reply-To: <4EE67D35.5000307@gmail.com>
Message-ID: <alpine.DEB.2.00.1112131013310.23111@router.home>
References: <4EE67D35.5000307@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, roel wrote:

> In mm/slab.c kmem_cache_init() at /* 4) Replace the bootstrap head arrays */
> it kmallocs *ptr and memcpy's with sizeof(struct arraycache_init). Is this
> correct or should it maybe be with sizeof(struct arraycache) instead?

Allocating with sizeof(struct arraycache) will only allocate the header of
the array cache and not reserve space for the pointers that are part of
it. It is always wrong.

Look at alloc_arraycache() for the proper way to use struct arraycache to
calculate the number of bytes needed.

