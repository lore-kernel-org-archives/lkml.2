Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab0GFRMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:12:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61613 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab0GFRMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NNpkLlwQqHanlQ8ia+br/eysTKSgvzL0dVqkrZT0/d/XZtfWgtnBm3R0WmqOQyB0Ne
         sL3WmE+7qigBL39UTAWMXGP+e+fFhd562UWH1kCO1YQBSui4KawGzHOQ4LIkUzVG+ity
         KqROBZtXcohC6i/CljrsyYtgmkHT8sbI8UW4c=
MIME-Version: 1.0
In-Reply-To: <1278238174.17566.4.camel@dermezel>
References: <1278238174.17566.4.camel@dermezel>
Date: Tue, 6 Jul 2010 12:12:11 -0500
Message-ID: <AANLkTil_Pu76aEje-5FP9nmxba--pmmAX3YkqNdzN3xX@mail.gmail.com>
Subject: Re: [PATCH] Staging: cx25821: fix brace coding style issue in 
	cx25821-audio-upstream.c
From: Aldo Cedillo <aldobrett11@gmail.com>
To: kagen101@gmail.com
Cc: gregkh@suse.de, mchehab@redhat.com, olimpiu.pascariu@gmail.com,
       julia@diku.dk, tj@kernel.org, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] Staging: cx25821: fix brace coding style issue in cx25821-audio-upstream.c
>  This is a patch to the cx25821.c file that fixes up a brace warning found by the checkpatch.pl tool
>  Signed-off-by: Joe Eloff <kagen101@gmail.com>
>
> ---
>  drivers/staging/cx25821/cx25821-audio-upstream.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
> index eb39d13..e7346ec 100644
> --- a/drivers/staging/cx25821/cx25821-audio-upstream.c
> +++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
> @@ -762,9 +762,9 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
>                       str_length + 1);


I haven't tried checkpatch.pl over that file, but in the CodingStyle
document you can read this:

Do not unnecessarily use braces where a single statement will do.

if (condition)
        action();

This does not apply if one branch of a conditional statement is a single
statement. Use braces in both branches.

if (condition) {
        do_this();
        do_that();
} else {
        otherwise();
}

Which one is the correct style? I ask these because I have seen this
in other parts of the kernel. So maybe I can help to homogenize this.

>                /* Default if filename is empty string */
> -               if (strcmp(dev->input_audiofilename, "") == 0) {
> +               if (strcmp(dev->input_audiofilename, "") == 0)
>                        dev->_audiofilename = "/root/audioGOOD.wav";
> -               }
I believe only this one has to go.
> +
>        } else {
So the first brace closes the brace of the if line.
>                str_length = strlen(_defaultAudioName);
>                dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);

Thanks,
Aldo Brett
