Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab1AIRio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 12:38:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57945 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1AIRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 12:38:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: On Linux numbering scheme
Date: Sun, 9 Jan 2011 18:38:22 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Claudio Scordino <claudio@evidence.eu.com>,
        Greg KH <gregkh@suse.de>
References: <27552986.2181294505105130.JavaMail.root@mail-zbox20.bo3.lycos.com>
In-Reply-To: <27552986.2181294505105130.JavaMail.root@mail-zbox20.bo3.lycos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101091838.22639.arnd@arndb.de>
X-Provags-ID: V02:K0:r52wG0IlzlysRMUVvw5khb+t1m5pLJMDxNHlElOCmHi
 vteV5eojtjTMtlVTEZvh9aOa72I7EEE8axi16sZlmk+wC/i70y
 yILGWwjCV3BzLuFNBU1T0vG1myZhUqcAmBFhKbaT6br3EFe82v
 /K8MFSy17tgj7OKCMqp8qPbf9vKHy+v/ox5Y2ZtKy+K8Sryic8
 CJXPBGcB8gYGpahsQ8Rgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 January 2011, Artem S. Tashkinov wrote:
> However sources of VMWare/NVIDIA/VBox/etc. kernel modules have multiples
> instances of:
> 
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 4, 7)
> #  error This driver does not support 2.4 kernels older than 2.4.7!
> #elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 5, 0)
> #  define KERNEL_2_4
> #elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 0)
> #  error This driver does not support 2.5 kernels!
> #elif LINUX_VERSION_CODE < KERNEL_VERSION(2, 7, 0)
> #  define KERNEL_2_6
> #else
> #  error This driver does not support development kernels!
> #endif
> 
> So, it seems like the only obstacle that stops us from starting a completely
> new numbering scheme is proprietary or corporations driven/developed software.

If that was the only obstacle, I'd advocate for using whatever scheme
breaks that code the most ;-)

Seriously, the entire problem is just in perception. The main thing
that's really wrong with the current scheme is that people tend to
see the difference between e.g. 2.6.27 and 2.6.37 as much smaller than
between 2.4.0 and 2.6.0, so there is less incentive to update to the
latest release, while in fact there were three years between the
releases in both cases and we are now a lot more active that we
used to be.

These days, the longterm releases really have the role of the old
even-numbered releases, in the way that distros rely on them for
stability, while the regular releases are used by a relatively small
group of people that are interested in using or developing new
features, like the old odd-numbered development releases.
This analogy ends when you look at the kinds of quality control
we apply to patches going into the longterm or the regular releases, 
compared to old even/odd cycles, but I think it's still useful
to consider it from this viewpoint.

I think it would be good to start the next longterm series with a
new number, since that would send an important message to the
end-users and give us better hopes of having a common longterm
tree for all enterprise and embedded people. It is however still
a lot of time until we need to replace 2.6.32/34/35-longterm, and the
incentive to change a name without any other consequences before
then is pretty low IMHO.

Most importantly, at the 2010 kernel summit it was decided to leave
the numbering alone for now. There certainly wasn't a lack of
ideas for how it should be named (2011/2.7/2.8/3.0/6.37/3.7/...).

	Arnd
