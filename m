Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab2CGSK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:10:26 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:33946 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2CGSKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:10:23 -0500
Message-ID: <4F57A48B.1060100@wwwdotorg.org>
Date: Wed, 07 Mar 2012 11:10:19 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: gxt@mprc.pku.edu.cn
CC: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>	 <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org> <1331103163.2048.33.camel@epip-laptop>
In-Reply-To: <1331103163.2048.33.camel@epip-laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 11:52 PM, Guan Xuetao wrote:
> On Tue, 2012-03-06 at 17:30 -0700, Stephen Warren wrote:
>> This allows the user to use U-Boot's mkimage's -T kernel_noload option
>> if their arch Kconfig allows it, and they desire.
...
> Hi, Stephen,
> It seems that UIMAGE_ARCH and UIMAGE_LOADADDR can't be modified from
> arch-Makefiles.

Oh dear, you're right. I suck at testing:-( I've fixed this locally.

For reference, Makefile.lib is included after the Makefile in the
relevant source directory, whereas my patch assumed the other way
around. So, rather than setting defaults in Makefile.lib and having
foo/Makefile override them, I should set the non-defaults in
foo/Makefile, and have Makefile.lib provide default values for variables
that aren't already set. Testing indicates this solves the problem!
