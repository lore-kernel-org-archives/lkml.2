Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1KYKr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:47:26 -0500
Received: from smtp-out-169.synserver.de ([212.40.185.169]:1074 "HELO
	smtp-out-169.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754044Ab1KYKrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:47:25 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 10860
Message-ID: <4ECF7274.2020502@metafoo.de>
Date: Fri, 25 Nov 2011 11:48:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com, stable@kernel.org
Subject: Re: [PATCH 4/8] firmware: Sigma: Mark firmware strutcs packed
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <1322138908-32127-4-git-send-email-lars@metafoo.de> <201111241219.37220.vapier@gentoo.org>
In-Reply-To: <201111241219.37220.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2011 06:19 PM, Mike Frysinger wrote:
> On Thursday 24 November 2011 07:48:23 Lars-Peter Clausen wrote:
>> Mark structs which are embedded into the firmware as packed to avoid
>> alignment issues.
> 
> while in general this makes sense, i designed the struct layout specifically to 
> work on any sane system.  that means 8bits align on 8bits, 16bits align on 
> 16bits, and 32bits align on 32bits.
> 
> do you see any place where this is not the case ?  otherwise, using __packed 
> by itself doesn't make much sense unless you also change all the loads from 
> the struct to the get_unaligned variety which would add useless overhead to 
> many embedded parts.
> 
> all in all, i'd omit the __packed markings since they're unnecessary.
> -mike

While you are right I think it's generally a good idea to mark anything as
packed, where we don't have direct influence on the alignment, to avoid
unpleasant suppresses. The compiler will usually take of performing proper
unaligned reads. I've though about adding a __aligned__(2) to the struct,
but since the majority of the data is 8bit data the overhead should be
negligible.

- Lars
