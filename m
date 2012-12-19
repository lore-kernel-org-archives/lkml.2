Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab2LSWrZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:47:25 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51365 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2LSWrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:47:19 -0500
MIME-Version: 1.0
In-Reply-To: <50D23EE8.7030904@zytor.com>
References: <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
	<CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
	<50CCCFD0.7030704@linux.intel.com>
	<CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
	<50CCEE49.3080801@zytor.com>
	<CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
	<50CCF6F6.4020107@zytor.com>
	<CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
	<50CD04F1.8020902@zytor.com>
	<0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
	<20121219220504.GA32212@jshin-Toonie>
	<50D23EE8.7030904@zytor.com>
Date: Wed, 19 Dec 2012 14:47:17 -0800
X-Google-Sender-Auth: gB1x6qU_2YCtHQrO0B14ADeITPY
Message-ID: <CAE9FiQWbyA4BgNFsxipdn=Mgc5c5tdSKzwbP_0nvs8BTqR0QUQ@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jacob Shin <jacob.shin@amd.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 2:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> The problem is that before we have awareness of the memory map, we need to
> map things in order to access them.  This is a big problem and right now
> there are ridiculous heuristics.  I have been working on mapping on demand,
> but there are concerns about the boundaries (i.e. what happens if the
> mapping spill over into a pit like this.)
>
> This kind of stuff is really not acceptable.  A region which will cause
> malfunction if prefetched should not be WB in the MTRR system (I include
> TOM* in that.)  The real question is what we can do to mitigate the damage.

on demand to only map 2M will help ?
or have to return to v6 version for-x86-boot ?
