Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1BBRO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:14:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab1BBRO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:14:56 -0500
Message-ID: <4D4990F8.5020204@zytor.com>
Date: Wed, 02 Feb 2011 09:14:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: Re: [PATCH] Fix EDD3.0 data verification.
References: <20110202112139.GD14984@redhat.com>
In-Reply-To: <20110202112139.GD14984@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 03:21 AM, Gleb Natapov wrote:
> Check for nonzero path in edd_has_edd30() has no sense. First, it looks
> at the wrong memory. Device path starts at offset 30 of the info->params
> structure which is at offset 8 from the beginning of info structure, but
> code looks at info + 4 instead. This was correct when code was introduced,
> but around v2.6.4 three more fields were added to edd_info structure
> (commit 66b61a5c in history.git). Second, even if it will check correct
> memory it will always succeed since at offset 30 (params->key) there will
> be non-zero values otherwise previous check would fail.
> 
> The patch replaces this bogus check with one that verifies checksum.
> 
> Signed-off-by: Gleb Natapov <gleb@redhat.com>

This is incorrect; the right thing to do is to use the length byte to
verify the range that should be checksummed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

