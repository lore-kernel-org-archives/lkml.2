Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1KPQXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:23:05 -0500
Received: from smtp-out-055.synserver.de ([212.40.185.55]:1188 "HELO
	smtp-out-054.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753121Ab1KPQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:23:03 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 15469
Message-ID: <4EC3E385.4060006@metafoo.de>
Date: Wed, 16 Nov 2011 17:23:33 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20111010 Iceowl/1.0b2 Icedove/3.1.15
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org, drivers@analog.com
Subject: Re: [PATCH 2/7] regmap: Make reg_config reg_defaults const
References: <1321457302-8724-1-git-send-email-lars@metafoo.de> <1321457302-8724-2-git-send-email-lars@metafoo.de> <20111116161316.GI29986@opensource.wolfsonmicro.com>
In-Reply-To: <20111116161316.GI29986@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2011 05:13 PM, Mark Brown wrote:
> On Wed, Nov 16, 2011 at 04:28:17PM +0100, Lars-Peter Clausen wrote:
>> The reg_defaults field usually points to a static per driver array, which should
>> not be modified. Make requirement this explicit by making reg_defaults const.
> 
> You should've got reams of sparse warnings from that - the indexed cache
> is writing to the defaults table (which is very naughty and i keep
> thinking about deleting it as a result).

This patch makes reg_defaults const in the reg_config struct not in the
regmap struct.

Since we duplicate the reg_config reg_defaults into the regmap reg_defaults
the index cache works on a runtime allocated array. (Though I wouldn't
object to see it gone. For the average uscase it uses more memory and is
slower than the rbnode cache).

- Lars
