Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab1KVQlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:41:09 -0500
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:37200 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757356Ab1KVQlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:41:07 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: PMWZKmkVM1m5NQd4X_nhSyx8jxwDrgjC1z9Mz.7mlzTRhlA
 IslP0ygy0ZruWJYJUijWYue9qsHgFyoQGMCRYRQBYfhcSSqq.8ShWEMsNR6T
 Jt1UV8JKFgpxqVGaxtRZqbPFU2rEcWKesPVr0_eSakTALROCbV4112ndiyWB
 MjIKWe_TMj7DNdhH7rr0WCbH0lEawHIpnIbZcRU3v1vTTmR94LNwRUyn6N3.
 jD5I5kb_RQ8GaJghvifQZithI6_E0GwL4_BKqL84x4WYvYprzYkL02jz9NG2
 mpiMYPDUPYM95Jbnckypdg6NssYxtvg4NJxlNarpLX6nZ4uP_.XSHNz1XK9F
 YhJfi95OUmAPpX1FQdRUgjI3GidU3b79Olo4Txj73sMlfCQ--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 Nov 2011 10:41:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
In-Reply-To: <alpine.DEB.2.00.1111221033350.28197@router.home>
Message-ID: <alpine.DEB.2.00.1111221040300.28197@router.home>
References: <alpine.DEB.2.00.1111221033350.28197@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1111221040302.28197@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Christoph Lameter wrote:

> It may be easier to simply disable interrupts early in __slab_free
> if debugging is on. Doesnt look nice right now. Draft patch (not tested
> yet):

Well thats not enough. We have to take the slab_lock to stop validate_slab
from checking up on things.

