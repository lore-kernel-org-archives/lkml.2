Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2DEUTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 16:19:55 -0400
Received: from mail.tpi.com ([70.99.223.143]:2324 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab2DEUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 16:19:54 -0400
Message-ID: <4F7DFE49.9040004@canonical.com>
Date: Thu, 05 Apr 2012 14:19:21 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120402 Thunderbird/11.0.1
MIME-Version: 1.0
To: Andy Whitcroft <apw@canonical.com>
CC: "Luis R. Rodriguez" <mcgrof@frijolero.org>, hauke@hauke-m.de,
        "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        lf_driver_backport@lists.linux-foundation.org,
        tim.gardner@canonical.com
Subject: Re: [PATCH] compat: add compat kernel checker and downloader
References: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org> <20120206160727.GA21048@tuxdriver.com> <20120207041958.GA32377@bombadil.infradead.org> <CAB=NE6VS79S4R6wQddQCqPfoYPyRbPzSdAYN2Mxfi-4G_sfCvg@mail.gmail.com> <CAB=NE6Wv3PEJj5zKfK2o869ntxuU3V+Nv2dgKX1eDtk3zQ04dA@mail.gmail.com> <CAB=NE6URWAgUgF+6bOsRBeeXnQ4VjYf1tWuUkkvMviCLOCxeqA@mail.gmail.com> <CAB=NE6UNHufTggg0ka-+q7ri_X6ENx4nO5DfMCAxxrKLrERPWg@mail.gmail.com> <CAB=NE6U_Sq88ro7onChn8U4tkkqt7Z9YN9wMyZjx+78j+M=_uA@mail.gmail.com> <20120404111014.GB3378@shadowen.org>
In-Reply-To: <20120404111014.GB3378@shadowen.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 05:10 AM, Andy Whitcroft wrote:
> On Fri, Mar 30, 2012 at 05:23:46PM -0700, Luis R. Rodriguez wrote:
>> Andy, so I just noticed that on all Ubuntu PPA (and generic) kernels
>> you guys have a broken symlink >= 2.6.33.
>>
>> /lib/modules/2.6.33-02063305-generic/build/include/asm
>>
>> points to asm-x86 and that is no longer present after 2.6.33 so any
>> module requiring those header files will break now on Ubuntu. I just
>> spotted this as some file from asm is now included in the modules were
>> are building. I guess not many external kernel modules include asm dir
>> otherwise you guys would have noticed this a long time ago.
> 
> Luis, I concur that the link is now broken.  However that link is actually
> simply superfulous now.  Anything correctly using kernel 'external
> module' support will be using the -I path from the kernel Makefiles.
> They will therefore be including from /usr/src/<version>/include _and_
> /usr/src/<version>/arch/x86/include.  I presume this is why we have not
> noticed it.
> 
> I will get that link removed however as it is simply bogus.
> 
> -apw
> 

I just corrected the invalid link so that it points at asm-generic.

http://bugs.launchpad.net/bugs/974403

rtg
-- 
Tim Gardner tim.gardner@canonical.com
