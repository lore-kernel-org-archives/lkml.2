Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab2HHTqs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:46:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62136 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2HHTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:46:46 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abraham Arce <x0066660@ti.com>,
        Syed Rafiuddin <rafiuddin.syed@ti.com>
Subject: Re: [PATCH] Input: omap4-keypad - don't leak in omap4_keypad_probe()
Date: Wed, 08 Aug 2012 12:46:40 -0700
Message-ID: <1545778.bUhk8oTdlK@dtor-d630.eng.vmware.com>
User-Agent: KMail/4.8.4 (Linux/3.5.0-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1208082135410.10061@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1208072014140.3227@swampdragon.chaosbits.net> <CAK9yfHxS=VvZ8Cuhd4LAUG+JnOK0g6=xCEoX45mtuVwj-+8D_g@mail.gmail.com> <alpine.LNX.2.00.1208082135410.10061@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 08, 2012 09:36:51 PM Jesper Juhl wrote:
> On Wed, 8 Aug 2012, Sachin Kamat wrote:
> > On 7 August 2012 23:46, Jesper Juhl <jj@chaosbits.net> wrote:
> > > If omap4_keypad_parse_dt() does not return 0 (zero) in
> > > omap4_keypad_probe() we will leak the memory we allocated for
> > > 'keypad_data' with kzalloc() when we return and the variable goes out
> > > of scope.
> > 
> > How about using devm_kzalloc() instead which will take care of freeing
> > the memory on detach?
> 
> Perhaps. I'm not (yet) familiar with how that function works, so I had
> not considered it. I'll look into it.

Actually please not yet - I guess at some point I'll have to add devm_*
variants for input_device_* operations but for now I prefer not to mix
the 2 styles of managing resources.

BTW, I think I need to redo a few patches so I plan on folding this fix
into the original change.

Thanks.
 
-- 
Dmitry
