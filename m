Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2H3OhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 10:37:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab2H3OhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 10:37:07 -0400
Message-ID: <503F7A8F.5050001@suse.cz>
Date: Thu, 30 Aug 2012 16:37:03 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Arokux B." <arokux@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Failure while make modules_install if kmod was compiled with
 --with-rootprefix set
References: <CAPNxggbrC7cKXYTKk=ivDL2ZT2w+5G4PACH1YT7iK-ZNk7twRQ@mail.gmail.com>
In-Reply-To: <CAPNxggbrC7cKXYTKk=ivDL2ZT2w+5G4PACH1YT7iK-ZNk7twRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.8.2012 23:50, Arokux B. wrote:
> Dear Mr. Marek, dear all,
> 
> I have detected a hidden failure while building the kernel. If
> --with-rootprefix is set for kmod, then depmod will look for modules
> installed at the location $ROOTPREFIX/lib/modules/<version>. The
> kernel build system does not know anything about $ROOTPREFIX, and so
> the wrong directory is created for the test if the hack is needed for
> an older versin of depmod at scripts/depmod.sh:19 mkdir -p
> "$tmp_dir/lib/modules/$KERNELRELEASE". That is why "$DEPMOD" -b
> "$tmp_dir" $KERNELRELEASE will always fail

I think we can revert the hack, because the three-digit version number
will stay for foreseeable future and depmod is not the only tool that
used to rely on this. However, what you describe looks like a bug in
kmod's depmod. -b sets the basedir, depmod should not prepend it with
any compiled-in string.

Michal
