Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0JQF6C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 01:58:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43627 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0JQF6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 01:58:00 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
In-Reply-To: <20101016192027.GA6883@infradead.org>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 17 Oct 2010 01:57:57 -0400
Message-ID: <1287295077.3020.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 15:20 -0400, Christoph Hellwig wrote:
> Besides the algorithmic problems with ima, why is kernel.org using
> IMA to start with?  Except for IBM looking for a reason to jusity why
> TPM isn't a completely waster of ressources it's pointless.  And it was
> only merged under the premise that it would not affect innocent normal
> users.
> 

Can we keep this at the design level please? When IMA is enabled, it
needs to store information on a per inode basis, yet has to wait to
late_initcall() for the TPM, at which point some inodes would have
already been created.  For this reason, there is a two step
initialization process, one which allocates the iints at
security_initcall() and the other which enables IMA at late_initcall().
Instead of actually allocating the iints, between security_initcall()
and late_initcall(), the original design maintained a list of inodes and
only allocated the iints if/when IMA was enabled. This design was
rejected way back when.

As for using a radix tree, that was what you recommended.

Mimi

