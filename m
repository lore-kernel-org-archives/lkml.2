Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030982Ab2HIPRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:17:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38753 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030785Ab2HIPRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:17:35 -0400
Message-ID: <5023D48D.4090901@wwwdotorg.org>
Date: Thu, 09 Aug 2012 09:17:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/3] regulator: add always set/clear masks to regulator_enable_regmap
References: <1344460727-6243-1-git-send-email-swarren@wwwdotorg.org> <20120809100930.GH24328@opensource.wolfsonmicro.com>
In-Reply-To: <20120809100930.GH24328@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 04:09 AM, Mark Brown wrote:
> On Wed, Aug 08, 2012 at 03:18:45PM -0600, Stephen Warren wrote:
> 
>> +				  rdev->desc->enable_mask |
>> +				  rdev->desc->en_dis_set_mask |
>> +				  rdev->desc->en_dis_clr_mask,
>> +				  rdev->desc->enable_mask |
>> +				  rdev->desc->en_dis_set_mask);
> 
> Two problems here.  One is that the names are *really* obscure and hard
> to read, the other is that this breaks all existing users.

OK. I can change this to whatever names you suggest.
enable_disable_clear_mask seems the least obscure, but rather long. Just
let me know what you want.

As for breaking existing users, I don't think so: The new fields will
presumably be initialized to zero for any drivers that don't explicitly
set them, and the values are simply or'd into the mask/value parameters
to update_bits(), and or'ing a zero will have no effect.
