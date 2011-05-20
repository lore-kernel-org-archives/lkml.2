Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934622Ab1ETBIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:08:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55962 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934262Ab1ETBIs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iSgsiR9b2UjLpLS98WEB+W4SL6toa2DWRMZ1ChqDQ7u2+B7XAdMsXhJMoeTXeYhSqX
         zzknPWRH+B1N9fY/3A0oBj79INHSDIESFdLt2w3nRtVk/7q6Rwh7sO/Ifmq1v1Kx8aRG
         WxmUFoz3u4aQrmL3XNHAWyLa4J0k17EjPlR7M=
MIME-Version: 1.0
In-Reply-To: <1305851709.7481.89.camel@pasglop>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<1305753895-24845-2-git-send-email-ericvh@gmail.com>
	<1305851709.7481.89.camel@pasglop>
Date: Thu, 19 May 2011 20:08:46 -0500
Message-ID: <BANLkTimEqYnTn10rV2=gfDkXfgxX+2OSCg@mail.gmail.com>
Subject: Re: [PATCH 2/7] [RFC] add bluegene entry to cputable
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 7:35 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
>> +             .dcache_bsize           = 32,
>> +             .cpu_setup              = __setup_cpu_460gt,
>                                            ^^^^^^^^^^^^^^^^^^
> Are you sure ?
>

That surprised me too, I figured it must have been a close enough
match (at least in the 2.6.29.1 time frame which is where I'm trying
to merge the BG/P patches up from.  The kittyhawk patches don't even
use this, so its possible we could just remove it.


_GLOBAL(__setup_cpu_460ex)
_GLOBAL(__setup_cpu_460gt)
        mflr    r4
        bl      __init_fpu_44x
        bl      __fixup_440A_mcheck
        mtlr    r4
        blr

Looks like the 460 setup invokes a bunch of 440 calls!  Would you
prefer I setup my own entry point (setup_cpu_bgp or setup_cpu_450)
which makes the same calls?

     -eric
