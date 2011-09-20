Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554Ab1ITN5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:57:39 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46519 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1ITN5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <1316524505-27272-2-git-send-email-zohar@linux.vnet.ibm.com>
References: <1316524505-27272-1-git-send-email-zohar@linux.vnet.ibm.com>
	<1316524505-27272-2-git-send-email-zohar@linux.vnet.ibm.com>
Date: Tue, 20 Sep 2011 16:57:36 +0300
Message-ID: <CAHp75VdUsefaFJYR07UCDG74yb03pbxWKO81PanmfK_yWt4y=g@mail.gmail.com>
Subject: Re: [PATCH 2/3] trusted-keys: check hex2bin result
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 4:15 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> For each hex2bin call in trusted keys, check that the ascii hex string is
> valid.  On failure, return -EINVAL.
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  security/keys/trusted.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/security/keys/trusted.c b/security/keys/trusted.c
> index 0c33e2e..9b847e1 100644
> --- a/security/keys/trusted.c
> +++ b/security/keys/trusted.c
> @@ -779,7 +779,9 @@ static int getoptions(char *c, struct trusted_key_payload *pay,
>                        opt->pcrinfo_len = strlen(args[0].from) / 2;
>                        if (opt->pcrinfo_len > MAX_PCRINFO_SIZE)
>                                return -EINVAL;
> -                       hex2bin(opt->pcrinfo, args[0].from, opt->pcrinfo_len);
> +                       if (!hex2bin(opt->pcrinfo, args[0].from,
> +                                    opt->pcrinfo_len))
> +                               return -EINVAL;
if (hex2bin(...) < 0)

Everywhere in Patch 2 and 3.

-- 
With Best Regards,
Andy Shevchenko
