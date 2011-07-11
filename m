Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1GKOV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:21:28 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59653 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1GKOV1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:21:27 -0400
MIME-Version: 1.0
In-Reply-To: <CADZ9YHiSmjtXx1Ue4tfUzN9zpj2qjABY_fhMP+SOm2_vYrrFfw@mail.gmail.com>
References: <cover.1310267866.git.luto@mit.edu> <e9c49596e493c1ebb80b52d2dff7bd50191ebc0e.1310267866.git.luto@mit.edu>
 <CADZ9YHiSmjtXx1Ue4tfUzN9zpj2qjABY_fhMP+SOm2_vYrrFfw@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 11 Jul 2011 08:21:07 -0600
X-Google-Sender-Auth: XkZhQ9Cxb2Fu_RYvtApGdLogCYU
Message-ID: <CAObL_7GZEQO1YUv2bco+2b=H98=pA-ZFUj1JZYZ_jG3KhSq8Fw@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] x86-64: Allow alternative patching in the vDSO
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 4:41 AM, Rakib Mullick <rakib.mullick@gmail.com> wrote:
> On Sun, Jul 10, 2011 at 9:22 AM, Andy Lutomirski <luto@mit.edu> wrote:

>> +static void patch_vdso(void *vdso, size_t len)
>
> I think, patch_vdso should mark with __init. Since it's been only
> called from an __init function. We might hit a section mismatch, even
> if we don't hit section mismatch, the will function get removed after
> system boot - saves some .text size.

Sure.  It won't make any difference, because my compiler at least is
smart enough to inline the whole function into init_vdso_vars, but
it's the right thing to do anyway.

>> +       return;  /* nothing to patch */
>
> If there's nothing to patch, I think (perhaps) - it would be nice to
> let user know through printk.

Will do.  I verified it myself by dumping the vdso image from memory
and confirming that it got patched correctly, but if the code ever
bitrots it'll be nice to have the warning.

--Andy
