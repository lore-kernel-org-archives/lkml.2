Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2F0Joo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:44:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34244 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538Ab2F0Jon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:44:43 -0400
Message-ID: <4FEAD606.9030605@mev.co.uk>
Date: Wed, 27 Jun 2012 10:44:38 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 36/36] staging: comedi: cb_pcidas: cleanup dac08_write()
References: <201206261812.16108.hartleys@visionengravers.com>
In-Reply-To: <201206261812.16108.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-27 02:12, H Hartley Sweeten wrote:
> Reverse the logic of the test against the cached value so that
> the function only has one exit point.
>
> Make the logic of the dac write a bit clearer by create a local
> variable for the address used in the outw() calls and masking the
> value to write and setting the enable bits before doing the outw()
> calls. Add a comment just to make sure it's clear.
>
> Also, add a comment about the 'return 1;'.  This should be
> insn->n which is the number of data parameters used to do the
> dac08_write_insn() but the insn is not a parameter to this
> function.

It's probably better to make dac08_write() return void and return 1 in 
dac08_write_insn().

Actually, I think dac08_write_insn() ought to call dac08_write() in a 
loop, iterating over data[] and return insn->n.  That's what the 
INSN_WRITE instruction is meant to do although it's not implemented all 
that consistently by the drivers.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-


