Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab0JOOcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 10:32:13 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:37937 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756012Ab0JOOcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 10:32:12 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: DMtQXAgVM1kKW9djOKvnGZ.wgeVStjXVq3wvMhKHIVuf42x
 EqywwoCwvKHY_Bf4m0xUwb8I5gQg22BkblYuBwxnuMY4X2MZo9IRzR7QzVY1
 jeeBlZijxRYzaREOB13Db1rRGBoAIlQ9HBAR3IPV.g.bbIA7iljG8VbfeWzd
 2HPIcVRB2rGHgWwl8qvJyapp3U9p30A8ajQ1rfZVfA1w3doxExiVTN4Pxyyb
 q
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 15 Oct 2010 09:32:09 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2] slub: Drop slab lock for partial list handling
In-Reply-To: <1287070497-2398-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1010150928030.22598@router.home>
References: <1287070497-2398-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Pekka Enberg wrote:

> There's no need to hold 'page' slab lock for partial list handling functions. A
> page is bound to a node so 'page->lru' is always protected by n->list_lock.

Only if there are no races introduced by dropping the lock early.

The freelist may be changed after dropping the slab lock. The
partial list operation may then end up adding a slab that is empty or full
to the partia list.

