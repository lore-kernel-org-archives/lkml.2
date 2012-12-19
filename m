Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab2LSQod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 11:44:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43251 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab2LSQo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 11:44:26 -0500
Date: Wed, 19 Dec 2012 16:44:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, akpm@linux-foundation.org,
        Xiaotian Feng <dannyfeng@tencent.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix inconsistent lock state
Message-ID: <20121219164408.GK4939@ZenIV.linux.org.uk>
References: <1355912802-2505-1-git-send-email-xtfeng@gmail.com>
 <dfadce3a-07b9-4760-9213-edf93abab2e7@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfadce3a-07b9-4760-9213-edf93abab2e7@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 04:13:30AM -0800, Eric W. Biederman wrote:

> Something doesn't feel right.   I don't think there should be a path where we get to proc_free_inum from bh context.
> 
> Rcu callbacks should be running in process context (if a special one).

No, they are not.  They run from softirq context, which makes for all kinds
of interesting kludges being required in various places.
