Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab1BBRZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:25:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1BBRZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:25:45 -0500
Date: Wed, 2 Feb 2011 19:25:34 +0200
From: Gleb Natapov <gleb@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
Message-ID: <20110202172534.GA24871@redhat.com>
References: <20110202112139.GD14984@redhat.com>
 <4D4990F8.5020204@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4990F8.5020204@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 02, 2011 at 09:14:32AM -0800, H. Peter Anvin wrote:
> On 02/02/2011 03:21 AM, Gleb Natapov wrote:
> > Check for nonzero path in edd_has_edd30() has no sense. First, it looks
> > at the wrong memory. Device path starts at offset 30 of the info->params
> > structure which is at offset 8 from the beginning of info structure, but
> > code looks at info + 4 instead. This was correct when code was introduced,
> > but around v2.6.4 three more fields were added to edd_info structure
> > (commit 66b61a5c in history.git). Second, even if it will check correct
> > memory it will always succeed since at offset 30 (params->key) there will
> > be non-zero values otherwise previous check would fail.
> > 
> > The patch replaces this bogus check with one that verifies checksum.
> > 
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> 
> This is incorrect; the right thing to do is to use the length byte to
> verify the range that should be checksummed.
> 
According to spec length should be set to 30 on exit.

--
			Gleb.
