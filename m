Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2K1Sdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 13:33:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35758 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2K1Sdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 13:33:43 -0500
Message-ID: <50B65903.1050400@wwwdotorg.org>
Date: Wed, 28 Nov 2012 11:33:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V7 1/7] kbuild: centralize .dts->.dtb rule
References: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1354058956-7199-1-git-send-email-swarren@wwwdotorg.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 04:29 PM, Stephen Warren wrote:
> All architectures that use cmd_dtc do so in almost the same way. Create
> a central build rule to avoid duplication. The one difference is that
> most current uses of dtc build $(obj)/%.dtb from $(src)/dts/%.dts rather
> than building the .dtb in the same directory as the .dts file. This
> difference will be eliminated arch-by-arch in future patches.
> 
> MIPS is the exception here; it already uses the exact same rule as the
> new common rule, so the duplicate is removed in this patch to avoid any
> conflict. arch/mips changes courtesy of Ralf Baechle.
> 
> Update Documentation/kbuild to remove the explicit call to cmd_dtc from
> the example, now that the rule exists in a centralized location.

Ben, Paul,

Following this patch (http://lkml.org/lkml/2012/11/27/555), I posted a
series of patches to convert almost all architectures to using the
centralized rule. The one architecture I didn't convert was PowerPC.

I didn't convert it because arch/powerpc/boot/Makefile contains a large
number of rules (to generate *Image.% where % is a board name) that
depend on %.dtb, which is expected to be in arch/powerpc/boot rather
than arch/powerpc/boot/dts. Now, I guess it's possible to convert them
all to expect the .dtb files to be in dts/ and also have
arch/powerpc/boot/Makefile call make in boot/dts/ to make each required
.dtb file. However, the patch would be a bit larger than all the other
architecture patches. Do you want me to do that conversion, or would you
rather I leave PowerPC alone? Thanks for any feedback.
