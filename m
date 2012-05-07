Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606Ab2EGS7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:59:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab2EGS7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:59:08 -0400
Message-ID: <4FA81CAB.1040405@suse.cz>
Date: Mon, 07 May 2012 21:04:11 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] kbuild: all{no,yes,mod,def,rand}config only read files
 when instructed to.
References: <20120507170319.03aa2fe980a39669c393a956@canb.auug.org.au> <m11umwjheu.fsf@fess.ebiederm.org>
In-Reply-To: <m11umwjheu.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 7.5.2012 14:37, Eric W. Biederman napsal(a):
> 
> Prevent subtle surprises to both people working on the kconfig code
> and people using make allnoconfig allyesconfig allmoconfig and
> randconfig by only attempting to read a config file if
> KCONFIG_ALLCONFIG is set.
> 
> Common sense suggests attempting to read the extra config files does
> not make sense unless requested.  The documentation says the code
> won't attempt to read the extra config files unless requested.
> Current usage does not appear to include people depending on the code
> reading the config files without the variable being set

It's true that this bug/feature has been there since the introduction of
KCONFIG_ALLCONFIG, but I doubt anyone relies on it.


> So do the
> simple thing and stop reading config files when passed
> all{no,yes,mod,def,rand}config unless KCONFIG_ALLCONFIG environment
> variable is set.

Yes! I applied to kbuild.git#kconfig, with Reported-by: Stephen. Thanks
to both of you.

Michal
