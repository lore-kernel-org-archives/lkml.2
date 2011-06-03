Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1FCF01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:26:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62610 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1FCF0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MwZbYFIAhUDyHEfY5QKik9k/r2eCNBDVY92PmITUQGtK5kIDoYJ1Dvs+r0fJYDYBLx
         AeqexIS2ru+w3Es7XxaW7e9vnL4cgIUZhEU0mYkfBGjOu63VJk5x3TCu82KUa0xWa+uG
         sszaQHv4j8XW+Fr7Tz5Oj5XYM4kOMoQBOasWU=
MIME-Version: 1.0
In-Reply-To: <4DE86B3D.1080806@reinelt.co.at>
References: <4DE86B3D.1080806@reinelt.co.at>
Date: Thu, 2 Jun 2011 22:26:22 -0700
X-Google-Sender-Auth: lKfHiKk0eI3lNk_XvhvqYcO373Y
Message-ID: <BANLkTikoQ1E9zJAUGeQTHs-ffLK=R7Wdsw@mail.gmail.com>
Subject: Re: mtrr_cleanup: can not find optimal value
From: Yinghai Lu <yinghai@kernel.org>
To: Michael Reinelt <michael@reinelt.co.at>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 10:03 PM, Michael Reinelt <michael@reinelt.co.at> wrote:
> Hi there,
>
> I'm suffering bad graphic performance on my notebook, and when sorting
> things out, I found the following in dmesg:
>
> mtrr_cleanup: can not find optimal value
> please specify mtrr_gran_size/mtrr_chunk_size
>
> and later:
>
> mtrr: type mismatch for e0000000,10000000 old: write-back new:
> write-combining
> [drm] MTRR allocation failed.  Graphics performance may suffer.
>
> which is probably due to the fact that MTRR's can't be cleaned (at least I
> suspect so)
>
> The notebook is a Fujitsu Liefbook E8410, Intel Core2 Duo CPU T7700 @
> 2.40GHz, and 8 GB RAM, graphics is Intel Mobile GM965/GL960, kernel is a
> vanilla 2.6.39 X86_64
>
> When I remove 1 RAM module (using 4GB only) the messages above disappear.
> Unfortunately, graphic performance is still bad, but that's another story. I
> want to fix the MTRR issue anyway.
>
> I think the MTRR cleaner is unable to find a really optimal combination, and
> wants me to specify one of the sub-optimal configs. But I have no idea how
> to do that, and found nothing in the net. I found some references to a
> "mtrr-uncover" program, but I cannot compile it (probably because its too
> old). So I'm asking for some advice how to manually tune the MTRR's.
...
>  gran_size: 8M  chunk_size: 32M         num_reg: 7      lose cover RAM: 7M
...
you can append "mtrr_gran_size=8M mtrr_chunk_size=32M" in boot command line.

Thanks

Yinghai
