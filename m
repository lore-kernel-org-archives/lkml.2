Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823Ab2HHTg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:36:57 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:14464 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030413Ab2HHTgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:36:53 -0400
Date: Wed, 8 Aug 2012 21:36:51 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        JJ Ding <dgdunix@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abraham Arce <x0066660@ti.com>,
        Syed Rafiuddin <rafiuddin.syed@ti.com>
Subject: Re: [PATCH] Input: omap4-keypad - don't leak in
 omap4_keypad_probe()
In-Reply-To: <CAK9yfHxS=VvZ8Cuhd4LAUG+JnOK0g6=xCEoX45mtuVwj-+8D_g@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1208082135410.10061@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1208072014140.3227@swampdragon.chaosbits.net> <CAK9yfHxS=VvZ8Cuhd4LAUG+JnOK0g6=xCEoX45mtuVwj-+8D_g@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2012, Sachin Kamat wrote:

> On 7 August 2012 23:46, Jesper Juhl <jj@chaosbits.net> wrote:
> > If omap4_keypad_parse_dt() does not return 0 (zero) in
> > omap4_keypad_probe() we will leak the memory we allocated for
> > 'keypad_data' with kzalloc() when we return and the variable goes out
> > of scope.
> 
> How about using devm_kzalloc() instead which will take care of freeing
> the memory on detach?
> 
Perhaps. I'm not (yet) familiar with how that function works, so I had 
not considered it. I'll look into it.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

