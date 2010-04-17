Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab0DQTa6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:30:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40006 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0DQTa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:30:57 -0400
Date: Sat, 17 Apr 2010 21:30:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Chetan Loke <generationgnu@yahoo.com>
Cc: Andi Kleen <andi@firstfloor.org>, rick.sherm@yahoo.com,
       linux-numa@vger.kernel.org, linux-kernel@vger.kernel.org,
       generationugnu@yahoo.com
Subject: Re: Memory policy question for NUMA arch....
Message-ID: <20100417193052.GD18855@one.firstfloor.org>
References: <20100417063523.GC18855@one.firstfloor.org> <398794.47398.qm@web111920.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <398794.47398.qm@web111920.mail.gq1.yahoo.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> PS - What do you think about __get_free_policy_pages(..)? Good/bad idea?

You can do it today by temporarily replacing the policy in current. It's somewhat
ugly. Interrupts don't use the policy, so it's not racy.

But yes if it's common it would seem reasonable to have a cleaner function for it,
if you have a clear use case and you can do it without impacting the page allocator fast path.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
