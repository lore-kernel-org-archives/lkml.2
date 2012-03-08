Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912Ab2CHWot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:44:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41006 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2CHWoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:44:46 -0500
Message-ID: <1331246669.11248.449.camel@twins>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, davej@redhat.com, jboyer@redhat.com,
        tyhicks@canonical.com, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2012 23:44:29 +0100
In-Reply-To: <20120308214425.GA23916@ZenIV.linux.org.uk>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20120308130256.c7855cbd.akpm@linux-foundation.org>
	 <20120308214425.GA23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 21:44 +0000, Al Viro wrote:
> I suspect that they right thing would be to have a way to set explicit
> nesting rules, not tied to speficic call trace. 

See might_lock() / might_lock_read(), these are used to implement
might_fault(), which is used to annotate paths that could -- but rarely
do -- fault.
