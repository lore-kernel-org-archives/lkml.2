Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1HAMKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 08:10:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42797 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1HAMKS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 08:10:18 -0400
MIME-Version: 1.0
In-Reply-To: <4E310C44.9050002@gmail.com>
References: <4E310C44.9050002@gmail.com>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 1 Aug 2011 20:09:37 +0800
Message-ID: <CANFwon1irVXA82qo7jM9ovNB8NFgRD-17Snta_Mg9h2xMYA29w@mail.gmail.com>
Subject: Re: [PATCH] Fix a argument WARN bug of scripts/checkpatch.pl
To: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

Thanks,
Hui

On Thu, Jul 28, 2011 at 15:14, gmail <teawater@gmail.com> wrote:
> Sorry the prev patch have the format error.  So I re-send it.
>
> Get following error with a patch that have min_t error:
> Use of uninitialized value in concatenation (.) or string at
> scripts/checkpatch.pl line 1256.
> WARNING:
> This is because:
>                                }
>                                WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
>                        }
> It lost the first argument.
> So make a patch to fix it.
>
> Signed-off-by: Hui Zhu <teawater@gmail.com>
> ---
>  scripts/checkpatch.pl |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2574,7 +2574,8 @@ sub process {
>                                } else {
>                                        $cast = $cast2;
>                                }
> -                               WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
> +                               WARN("MINMAX",
> +                                    "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
>                        }
>                }
>
>
