Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab3ADUfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:35:15 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36481 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755172Ab3ADUfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:35:13 -0500
Date: Fri, 4 Jan 2013 21:35:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Steven A. DuChene" <linux-clusters@mindspring.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: no config opt for k8temp in 3.6.11
Message-ID: <20130104203525.GA24247@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Steven A. DuChene" <linux-clusters@mindspring.com>,
	linux-kernel@vger.kernel.org
References: <19235668.1357309514415.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19235668.1357309514415.JavaMail.root@mswamui-valley.atl.sa.earthlink.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 09:25:14AM -0500, Steven A. DuChene wrote:
> I have a few systems with AMD processors. One is a AMD Phenom II based
> system which uses a k10temp kernel module to get the CPU temperature.
> Another system has an Athlon64 processor which apparently is supposed
> to use a k8temp module to do the same thing. I have built a 3.6.11
> kernel for each system that otherwise runs OpenSuSE-11.X. On the
> Phenom system the k10temp module is gets built and performs as
> expected. However on the Atlnon system even though I see the k8temp.c
> source file in the drivers/hwmon directory there does not seem to be
> a way in the kernel config files available from the 3.6.11 kernel
> sources to actually select that the k8temp module should be built. Is
> this some oversight in the makeup of the kernel config files or am I
> missing something obvious?

That's strange, I can select all the AMD power drivers on 3.6.11:

$ grep -E "^CONFIG_SENSORS" .config
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m

Can you do 'make mrproper' and try regenerating your config? But
remember, mrproper will remove your .config so you might want to save
that upfront in case you need it.

HTH.

-- 
Regards/Gruss,
Boris.
