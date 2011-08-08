Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab1HHSOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:14:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab1HHSOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:14:50 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 06/11] DIO: Inline the complete submission path v2
References: <1312259893-4548-1-git-send-email-andi@firstfloor.org>
	<1312259893-4548-7-git-send-email-andi@firstfloor.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 14:14:43 -0400
In-Reply-To: <1312259893-4548-7-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Mon, 1 Aug 2011 21:38:08 -0700")
Message-ID: <x49liv3hiss.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> From: Andi Kleen <ak@linux.intel.com>
>
> Add inlines to all the submission path functions. While this increases
> code size it also gives gcc a lot of optimization opportunities
> in this critical hotpath.
>
> In particular -- together with some other changes -- this
> allows gcc to get rid of the unnecessary clearing of
> sdio at the beginning and optimize the messy parameter passing.
> Any non inlining of a function which takes a sdio parameter
> would break this optimization because they cannot be done if the
> address of a structure is taken.

Do you want to use __always_inline, then?

Cheers,
Jeff
