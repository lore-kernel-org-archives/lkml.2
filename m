Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1AZATF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:19:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:46479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab1AZATE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:19:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,377,1291622400"; 
   d="scan'208";a="596462999"
From: Andi Kleen <ak@linux.intel.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/20] hpfs: replace BKL with a global mutex
In-Reply-To: <1295993854-4971-11-git-send-email-arnd@arndb.de> (Arnd
	Bergmann's message of "Tue, 25 Jan 2011 23:17:24 +0100")
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-11-git-send-email-arnd@arndb.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Cancel-Lock: sha1:cl7TDsgqLfqlaIQ8OVB4pEoFwr8=
Date: Tue, 25 Jan 2011 16:19:09 -0800
Message-ID: <m2ipxc34aq.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> This removes the BKL in hpfs in a rather awful
> way, by replacing it with a mutex that basically
> serializes the entire file system.

I don't think that's a very good idea, there's danger
of holding it over IO and that would be really bad (as in like MINIX[1])

It would be better to do it the i810 way and check for the number of
CPUs at module init time and refuse to run if it's > 1

-Andi

[1] showing my age
-- 
Andi Kleen
Intel Open Source Technology Center
