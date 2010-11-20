Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0KTVhj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 16:37:39 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35765 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0KTVhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 16:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RRJqwLduNmYAVWbqELYI6doiYVZv5ExOj0opk+A4LuuBiTNs0aql1DJpZZq9rqCCBd
         0ZpxNVFcrMbQYBjvWWxTFmmAx8BTOsbdD+XRWr3ZyCQ5Wm9Ct+ri5xskg07WOf6aPzDh
         1PzCPWZOh4/mfYCQpLAVe/R3TDG0CrK/sWKEc=
Date: Sat, 20 Nov 2010 13:37:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH RFC] serio HIL MLC: don't deref null, don't leak and
 return proper error
Message-ID: <20101120213730.GA16712@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1011072024100.26247@swampdragon.chaosbits.net>
 <20101109063520.GA10502@core.coreip.homeip.net>
 <4CE83A09.5020000@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE83A09.5020000@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 10:13:45PM +0100, Helge Deller wrote:
> On 11/09/2010 07:35 AM, Dmitry Torokhov wrote:
> >On Sun, Nov 07, 2010 at 08:36:33PM +0100, Jesper Juhl wrote:
> >>Hi,
> >>
> >>While reviewing various users of kernel memory allocation functions I came
> >>across drivers/input/serio/hil_mlc.c::hil_mlc_register() and noticed that
> >>  - it calls kzalloc() buf fails to check for a NULL return before use.
> >>  - it makes several allocations and if one fails it doesn't free the
> >>    previous ones.
> >>  - It doesn't return -ENOMEM in the failed memory allocation case (it just
> >>    crashes).
> >>This patch corrects all of the above and also reworks the only caller of
> >>this function that I could find
> >>(drivers/input/serio/hp_sdc_mlc.c::hp_sdc_mlc_out()) so that it now checks
> >>the return value of hil_mlc_register() and properly propagate it on
> >>failure and I also restructured the code to remove some labels and goto's
> >>to make it, IMHO nicer to read.
> >>
> >>I have no hardware to test, so please review carefully and let me know if
> >>I've done something completely stupid. Please don't merge this RFC patch
> >>unless at least one or more people who know this code and can actually
> >>test it have ACK'ed it.
> >I think Helge Deller (CCed) used to have access to such hardware...
> 
> Yes, and I tested the patch successfully.
> 
> Tested-by: Helge Deller <deller@gmx.de>
> Acked-by: Helge Deller <deller@gmx.de>
> 

Applied, thank you guys.

-- 
Dmitry
