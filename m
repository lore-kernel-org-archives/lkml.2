Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794Ab0JFLNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 07:13:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:52915 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab0JFLNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 07:13:30 -0400
Message-ID: <4CAC59D4.5010505@suse.cz>
Date: Wed, 06 Oct 2010 13:13:24 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: linux-next: build warnings after merge of the kbuild-current
 tree
References: <20101006114433.4fbe86ef.sfr@canb.auug.org.au>
In-Reply-To: <20101006114433.4fbe86ef.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.10.2010 02:44, Stephen Rothwell wrote:
> Hi Michal,
> 
> After merging the kbuild-current tree, today's (and yesterday's)
> linux-next build (x86_64 allmodconfig and other builds as well) produced
> these warnings:
> 
> warning: [...] selects I2C_ALGOBIT which has unmet direct dependencies (I2C && !I2C_HELPER_AUTO)
> [...]
> warning: [...] selects VIDEO_TVAUDIO which has unmet direct dependencies (MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && !VIDEO_HELPER_CHIPS_AUTO && VIDEO_V4L2 && I2C)
> 
> After reverting commit ff5ff6060bf880aac233e68dd666cbe9e39ec620
> ("kconfig: delay symbol direct dependency initialization") it produces no
> such warnings.

I'm aware of them. I'm talking with Jean Delvare about fixing the I2C
warnings, see http://lkml.org/lkml/2010/10/5/83. The drivers/media/video
warnings will need the same care. I don't know if we manage to fix these
in time, so maybe the kconfig fix will have to way for 2.6.36.1.

Michal

