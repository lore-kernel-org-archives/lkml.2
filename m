Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab0GaKGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 06:06:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58415 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab0GaKGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 06:06:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eSHYSyn9U5YZTJtFsJu8Io9bK1VQz+MLrcmapV3+gMqBAVYIdVEUubUe0hul+zY4QZ
         NQPtkFp9J27VA6jiJkGf2IBFh9UxiE+PJpfqpvzebBplqYrBbQCbTiaPM+1wJzEdw27V
         p+3rjPlcxwBHtqg+H5pT64Bz/BWl+kZmfcW1s=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1007201518470.9608@router.home>
References: <AANLkTimVSZ584-dTIJFalTStvT1kPBQmnDdgUTsoSFQT@mail.gmail.com>
	<AANLkTikZLVYavu0EeQJ2VelymBoC2LQZTfc44FOAzwe4@mail.gmail.com>
	<alpine.DEB.2.00.1007201518470.9608@router.home>
Date: Sat, 31 Jul 2010 12:06:22 +0200
Message-ID: <AANLkTimZhoLA8snZkUYGTnRYriYzrPvnLw6AM7NaJBcx@mail.gmail.com>
Subject: Re: Regression 2.6.33->2.6.34: OOPS at boot, kmalloc corruption?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 10:19 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> On Tue, 20 Jul 2010, Pekka Enberg wrote:
>
>> It's slab corruption that can be cause by many things. Can you please
>> try to reproduce with CONFIG_SLUB_DEBUG_ON=y?
>
> Or simply reboot and add a parameter slub_debug to the other parameters.

I finally had the opportunity to reboot this system again.

CONFIG_SLUB_DEBUG=y was set, so I tried adding slub_debug to the commandline.

With slub_debug added the system boots normal, I could not see any
errors in the syslog. When I remove slub_debug it crashed againb
before reaching userspace.

After the KMS fixes from Alex Deucher vanilla kernel 2.6.35-rc6 works
for me. So I would thing my problems with earlier 2.6.35-rcs where
just these KMS errors and this kmalloc problem has already been fixed
in mainline.

So I have switched this system to 2.6.35-rc6 and will stay with this kernel.

Thanks, Torsten
