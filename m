Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2HMOHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:07:52 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60041 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab2HMOHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:07:51 -0400
MIME-Version: 1.0
In-Reply-To: <1344610429-12607-1-git-send-email-richard.genoud@gmail.com>
References: <1344610429-12607-1-git-send-email-richard.genoud@gmail.com>
Date: Mon, 13 Aug 2012 16:07:50 +0200
Message-ID: <CACRpkdb35wAU2heADSKwCRqPEemmFgvd_1C=qNCkvjWwJbQK-g@mail.gmail.com>
Subject: Re: [PATCH] trivial: pinctrl core: remove extraneous code lines
From: Linus Walleij <linus.walleij@linaro.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 4:53 PM, Richard Genoud
<richard.genoud@gmail.com> wrote:

> In function pinctrl_get_locked, pointer p is returned on error, and also
> return on no_error.
> So, we just return it with no error test.
>
> It's pretty the same in function pinctrl_lookup_state_locked: state is
> returned in every case, so we drop the error test and just return state.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>

Applied. While I sort of agree with Stephen on the point of the
second hunk being cleaner as it was, it's no big deal so whatever.

I took this opportunity to cut some parens tho:

@@ -657,11 +657,7 @@ static struct pinctrl *pinctrl_get_locked(struct
device *dev)
        if (p != NULL)
                return ERR_PTR(-EBUSY);

-       p = create_pinctrl(dev);
-       if (IS_ERR(p))
-               return p;
-
-       return p;
+       return create_pinctrl(dev);
 }

 /**
@@ -738,11 +734,8 @@ static struct pinctrl_state
*pinctrl_lookup_state_locked(struct pinctrl *p,
                        dev_dbg(p->dev, "using pinctrl dummy state (%s)\n",
                                name);
                        state = create_state(p, name);
-                       if (IS_ERR(state))
-                               return state;
-               } else {
-                       return ERR_PTR(-ENODEV);
-               }
+               } else
+                       state = ERR_PTR(-ENODEV);
        }


Yours,
Linus Walleij
