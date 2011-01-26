Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab1AZAQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 19:16:07 -0500
Received: from lo.gmane.org ([80.91.229.12]:50847 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab1AZAQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 19:16:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 10/20] hpfs: replace BKL with a global mutex
Date: Tue, 25 Jan 2011 16:15:51 -0800
Message-ID: <m2oc7434g8.fsf@firstfloor.org>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
	<1295993854-4971-11-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: jfdmzpr02-ext.jf.intel.com
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Cancel-Lock: sha1:cl7TDsgqLfqlaIQ8OVB4pEoFwr8=
Cc: linux-fsdevel@vger.kernel.org
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

