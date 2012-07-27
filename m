Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2G0Kct (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 06:32:49 -0400
Received: from osrc3.amd.com ([217.9.48.20]:46568 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab2G0Kcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 06:32:48 -0400
Date: Fri, 27 Jul 2012 12:32:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 08/13] driver core: firmware loader: fix device
 lifetime
Message-ID: <20120727103241.GB14445@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-9-git-send-email-ming.lei@canonical.com>
 <20120725160425.GK11152@aftab.osrc.amd.com>
 <CACVXFVO5HHFraBXsV2S_a_KUrBg3ffyO0qqaGCjzq8Rksr9KaA@mail.gmail.com>
 <20120726122016.GD30717@aftab.osrc.amd.com>
 <CACVXFVMxUKezcR5BBv6jM0wZr8UivF7dJGe1gLNiFx=1h4U59g@mail.gmail.com>
 <20120726174617.GA9161@aftab.osrc.amd.com>
 <CACVXFVOrQg56VKv22i3ydm5Vw6o=UTzDJP6-_NUiyXbD46wNhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOrQg56VKv22i3ydm5Vw6o=UTzDJP6-_NUiyXbD46wNhQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 09:30:57AM +0800, Ming Lei wrote:
> No, the comment above is misleading and not useless, and I think the below
> is good:
> 
>  *      Asynchronous variant of request_firmware() for user contexts where
>  *      it is not possible to sleep for long time or can't sleep at all, depends

									depending

>  *      on the @gfp flag passed.
> 
> Anyway, the original part of 'It can't be called in atomic contexts.' is wrong
> and should be removed.

I still don't like too much the "not possible to sleep for long time"
expression.

Maybe change it to "should sleep for as small periods as possible since
it increases boot time of device drivers requesting firmware in their
->probe() methods."

This way you explain exactly why - this way people who don't know the
code will know exactly what the comments mean and what the intention
was.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
