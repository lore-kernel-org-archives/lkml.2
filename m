Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab1ALMoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:44:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38018 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab1ALMoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:44:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zsel5J0LnZf5SggKE1SpfkmYItZYFnEwomGbJ0lHH7k5cT63GYio3RoGHg85QyMrGw
         ZBCCmpzKuLUu1JlKYU5pPqZnBs/mlFUtsAirbL44xPdAXv0FQAcNNJA8uVBj28T8H2li
         2bpju0nMeMaQUc/ek51XYdCMYLbvnSM8RfRNY=
MIME-Version: 1.0
In-Reply-To: <201101121203.55901.hanno@hboeck.de>
References: <201101121203.55901.hanno@hboeck.de>
Date: Wed, 12 Jan 2011 14:44:07 +0200
Message-ID: <AANLkTi=SJpxh5h774shB+MW=xM8cyfunyJYO0deU9mCT@mail.gmail.com>
Subject: Re: [PATCH] sound: constify functions in ac97
From: Alexey Dobriyan <adobriyan@gmail.com>
To: =?ISO-8859-1?Q?Hanno_B=F6ck?= <hanno@hboeck.de>
Cc: alsa-devel@alsa-project.org, perex@perex.cz, tiwai@suse.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 1:03 PM, Hanno Böck <hanno@hboeck.de> wrote:
>  struct snd_ac97_build_ops {
> -       int (*build_3d) (struct snd_ac97 *ac97);
> -       int (*build_specific) (struct snd_ac97 *ac97);
> -       int (*build_spdif) (struct snd_ac97 *ac97);
> -       int (*build_post_spdif) (struct snd_ac97 *ac97);
> +       int (* const build_3d) (struct snd_ac97 *ac97);
> +       int (* const build_specific) (struct snd_ac97 *ac97);
> +       int (* const build_spdif) (struct snd_ac97 *ac97);
> +       int (* const build_post_spdif) (struct snd_ac97 *ac97);
>  #ifdef CONFIG_PM
> -       void (*suspend) (struct snd_ac97 *ac97);
> -       void (*resume) (struct snd_ac97 *ac97);
> +       void (* const suspend) (struct snd_ac97 *ac97);
> +       void (* const resume) (struct snd_ac97 *ac97);
>  #endif
> -       void (*update_jacks) (struct snd_ac97 *ac97);   /* for jack-sharing */
> +       /* for jack-sharing */
> +       void (* const update_jacks) (struct snd_ac97 *ac97);

Can we please not do this.

You made whole ops structure RO, this is enough.
