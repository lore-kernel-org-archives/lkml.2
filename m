Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab2BJMb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 07:31:56 -0500
Received: from smtp-out-165.synserver.de ([212.40.185.165]:1042 "EHLO
	smtp-out-158.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754727Ab2BJMbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 07:31:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 27182
Message-ID: <4F350E8C.6030907@metafoo.de>
Date: Fri, 10 Feb 2012 13:33:16 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regmap: Support for caching in reg_raw_write()
References: <1328873572-12603-1-git-send-email-ldewangan@nvidia.com> <4F350716.9050407@metafoo.de> <20120210121405.GD6472@opensource.wolfsonmicro.com>
In-Reply-To: <20120210121405.GD6472@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 01:14 PM, Mark Brown wrote:
> On Fri, Feb 10, 2012 at 01:01:26PM +0100, Lars-Peter Clausen wrote:
> 
>> In my opinion it makes more sense to introduce a regmap_bulk_write function
>> for this. regmap_raw_write was not really meant to write registers but
> 
> This isn't exclusive to that, I think Laxman planned to send a patch
> doing that on top of this one which would be what most users would end
> up using.
> 
>> rather binary blobs, like firmware. Also this keeps things consistent with
>> the read part of the regmap API.
> 
> See the previous discussion on this in the past day or so - bulk_write()
> is more complicated to implement by itself since it's going to end up
> boling down to a raw_write() internally anyway (as does reg_write()) and
> it seems nicer to just do the right thing if people ask for it.  
>

regmap_write doesn't always go the raw_write path. Also with this approach
we end up formatting the value into the raw format, only to parse it again
in the next step.

Furthermore I don't think it makes sense to cache raw values as the cache
operates on a register level, not on a byte level.
