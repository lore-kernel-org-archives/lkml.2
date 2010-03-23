Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0CWHHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 03:07:09 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:44711 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549Ab0CWHHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 03:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <1269327424.5953.12.camel@concordia>
References: <20100318144836.21082.93040.stgit@angua> <1269327424.5953.12.camel@concordia>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 23 Mar 2010 01:06:42 -0600
X-Google-Sender-Auth: a069286a958bbc80
Message-ID: <fa686aa41003230006v6098afe7s1bcb64f409f11a5a@mail.gmail.com>
Subject: Re: [V2 PATCH 00/10] of: Consolidate scattered device node pointers 
	in struct device
To: michael@ellerman.id.au
Cc: davem@davemloft.net, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 12:57 AM, Michael Ellerman
<michael@ellerman.id.au> wrote:
> On Thu, 2010-03-18 at 09:22 -0600, Grant Likely wrote:
>> Currently, each of_device has a copy of the device tree node pointer in both
>> .node, and in .dev.archdata.of_node (microblaze and powerpc) or
>> .dev.archdata.prom_node (sparc).  Also, other architectures will be adding
>> CONFIG_OF support, and they will also need a reference to the device tree
>> node pointer from struct device.
>
> Assuming this is similar to your experimental-devicetree branch, as of
> 96b4b9d7 it causes a few build errors for me:
>
> http://kisskb.ellerman.id.au/kisskb/head/2688/
>
> Broken are 86xx/sbc8641d_defconfig, mpc83xx_defconfig,
> mpc885_ads_defconfig, mpc85xx_defconfig, and pmac32_defconfig.

Hey Michael,

Thanks for the testing.  I haven't built through all the defconfigs
yet so this doesn't surprise me too much that I've missed some
drivers.  The failure is caused in the last three commits which remove
the old variables.  I'll pick through the failing defconfigs, fix and
test them, and refresh my branch.

I'll let you know when the branch is updated.

Cheers,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
