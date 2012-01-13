Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879Ab2AMTM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 14:12:28 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:60997 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab2AMTMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 14:12:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=O2YoUm9EmwTR3gRZSX4UfbgVjo0lQRKY
	m/BTQ5vUfyOoC/pU1DevlxuAdlZ/GS5mZwDKY6XJknMrFlfmM2TICZeU+4XYjM9c
	EnwJhH71/lfH8ekAhbcTobCxNS6fQcKQfuN3LZw6VBYaK8Bz2U8XANeyJbw0FVRA
	/YaVKx+4pCM=
From: Junio C Hamano <gitster@pobox.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, <linux-kernel@vger.kernel.org>,
        Git Mailing List <git@vger.kernel.org>
Subject: Re: [PATCH] merge: Make merge strategy message follow the diffstat
References: <20120109073727.GF22134@opensource.wolfsonmicro.com>
 <CA+55aFyhoh0rT_ujuE1w3RpuR7kqivYFwPpm66VC-xtq1PiGUQ@mail.gmail.com>
 <20120110184530.GE7164@opensource.wolfsonmicro.com>
 <CA+55aFxXb7wqfrpozS6iH0k25y-+Uy8_Tavv59JXMhaWrjXLaw@mail.gmail.com>
 <20120110222711.GK7164@opensource.wolfsonmicro.com>
 <CA+55aFxvQF=Bm4ae6euB_UO8otMCuN9Lv37Zn3TpE-L7JH3Kzw@mail.gmail.com>
 <20120111184026.GA23952@windriver.com>
Date: Fri, 13 Jan 2012 11:12:22 -0800
In-Reply-To: <20120111184026.GA23952@windriver.com> (Paul Gortmaker's message
 of "Wed, 11 Jan 2012 13:40:27 -0500")
Message-ID: <7vaa5rzaax.fsf_-_@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 865735AC-3E1A-11E1-9DDB-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

> By moving the message after the diffstat, there is a better chance that
> people will be aware they've done a pointless merge commit.
>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

I think the goal of the change may be worthy, but a few points:

 - What does "automsg" mean? Is "auto" in contrast to "manual"? Even
   better, wouldn't it be far simpler to just use

	if (msg && verbosity >= 0)
		printf("%s\n", msg);

   and get rid of this mysteriously named variable altogether?

 - Wouldn't it make more sense to move "No merge message -- not updating
   HEAD" also to the end?

 - After applying this patch, does the tests still pass?

Thanks.

