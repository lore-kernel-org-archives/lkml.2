Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1BNUAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 15:00:46 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43297 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab1BNUAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 15:00:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qhU7Jehv0iDvhXro+At5kL5jt25unF/b7F5sHPF9fs3ydAmxydhJclC2L3gKidrfmv
         iRntZovu+YL5CdOxE5Qz3AW9CpfXBnteT0FOjT7g4Bjb+285zp+8WvZQNT8VowWv7bok
         In/d9hMLdH9KlJX0SBQvWwONB04M3+LEdGrBs=
MIME-Version: 1.0
In-Reply-To: <1297711715-3086-1-git-send-email-tj@kernel.org>
References: <1297711715-3086-1-git-send-email-tj@kernel.org>
Date: Mon, 14 Feb 2011 12:00:43 -0800
X-Google-Sender-Auth: Y-A2Jcj2Pf7IJVMTztoCT18K_5o
Message-ID: <AANLkTikNy-vQ2V95dhyQ8k1jkQCiUOukY8ShP_GWM1w6@mail.gmail.com>
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA emulation
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com, ankita@in.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 11:28 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> NUMA emulation is quite convoluted involving unnecessary mapping and
> reverse mapping between apicids, PXMs, nodes and memory addresses.
> This patchset tries to restore some sanity to the whole thing.
>
> Tested on an opteron NUMA machine which can do both ACPI and AMD
> configs.  All NUMA configs, emulations, !NUMA and UP work as expected.
>
> This patchset is on top of tip/x86/numa[1] +
> bring-sanity-to-NUMA-configuration patchset[2] and contains the
> following 7 patches.
>
>  0001-x86-64-NUMA-Trivial-changes-to-prepare-for-emulation.patch
>  0002-x86-64-NUMA-Build-and-use-direct-emulated-nid-phys-n.patch
>  0003-x86-64-NUMA-Make-emulation-code-build-numa_meminfo-a.patch
>  0004-x86-64-NUMA-Wrap-node-ID-during-emulation.patch
>  0005-x86-64-NUMA-Emulate-directly-from-numa_meminfo.patch
>  0006-x86-64-NUMA-Unify-emulated-apicid-node-mapping-trans.patch
>  0007-x86-64-NUMA-Unify-emulated-distance-mapping.patch
>
> The patchset is available in the following git branch.
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify
>
> Diffstat follows.
>
>  arch/x86/include/asm/acpi.h    |    6
>  arch/x86/include/asm/amd_nb.h  |    4
>  arch/x86/include/asm/numa_64.h |    1
>  arch/x86/mm/amdtopology_64.c   |   47 ----
>  arch/x86/mm/numa_64.c          |  429 ++++++++++++++++++-----------------------
>  arch/x86/mm/srat_64.c          |   87 --------
>  6 files changed, 197 insertions(+), 377 deletions(-)

wonder if numa_emu code could be put into one single file like numa_emu.c

Yinghai
