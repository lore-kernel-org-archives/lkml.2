Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0HBRtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:49:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52600 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0HBRtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:49:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=erkb/QDPOilE1q5zVVQCU8wPyflUuGzD1gBkhXGhrEGnAWUvGWB41ePfaeUcatjtPo
         TmFZTXJ7+p41Lb/9sPdDvmkCRXeHQ5xQYlULvL0fErRVbNEalY3zjSmlzdeInVEG5iAF
         n3dVZ8ycZNlCOphzXocmbMpOT3RR5XIYf4vZs=
Date: Mon, 2 Aug 2010 21:49:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from
	compressed/misc.c
Message-ID: <20100802174916.GD5544@lenovo>
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C568D6F.3050004@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 02:18:39AM -0700, Yinghai Lu wrote:
> 
> will get
> 
> |Decompressing Linux... Parsing ELF... done.
> |Booting the kernel.
> 
> in serial console.
> 
> reuse code from arch/x86/boot/
> and we can use printf if needed
> 
> -v2: define BOOT_BOOT_H to avoid include boot.h
> -v3: early_serial_base need to be static in misc.c ?
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/boot/compressed/misc.c |   65 +++++++++++++++++++++++++++++++++++++++-
>  arch/x86/boot/main.c            |    6 +--
>  2 files changed, 66 insertions(+), 5 deletions(-)
> 

It seems eventually we just add ~80 lines of code in compare with what we had before,
just to print "Decompressing..." by serial line. Not sure Yinghai if it worth
it. Though having printf that early might be quite useful for those who debugging
or developing new compressors/decompressors. If it would be small non-intrusive
patch I would both hands for it but now I simply don't know (to be fair mine
proposal based on your initial patch not better either ;)

	-- Cyrill
