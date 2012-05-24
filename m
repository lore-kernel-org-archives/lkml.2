Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2EXIx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:53:57 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:33896 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2EXIxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:53:54 -0400
Message-ID: <4FBDF715.4050808@mev.co.uk>
Date: Thu, 24 May 2012 09:53:41 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120516 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: comedi: remove this_board macro in the s526
 driver
References: <201205221820.10770.hartleys@visionengravers.com> <20120523054849.GK4637@mwanda> <4FBCAB50.5000907@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698BAC8D8@AUSP01VMBX24.collaborationhost.net> <20120523190715.GP4629@mwanda>
In-Reply-To: <20120523190715.GP4629@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-23 20:07, Dan Carpenter wrote:
> On Wed, May 23, 2012 at 11:28:32AM -0500, H Hartley Sweeten wrote:
>> This would allow comedi_recognize() to walk the boardinfo
>> to find the match without all the ugly casts.
>
> That function wouldn't be so bad if we just removed all the consts.
> There is no point because we drop all of them anyway when we return
> the struct.

Well maybe some of the consts.  We could use const char **name_ptr 
instead of const char *const *name_ptr.  *name_ptr is never modified, 
but as name_ptr is just a local variable, the compiler can figure that 
out for itself without the extra const.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
