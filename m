Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab0FEVBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 17:01:49 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50561 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0FEVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 17:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=eh1eTR1V3hPX52Ohhf63qBlQ/s5u3vqT0FUcIrQarS38HpYdZu275Tt54eh+T92URe
         lqqQwx3NQm+26FmD/eTf9PmXd8baxDip7+LVerMulQ2kkWnYJV21fS2gT6kqs6cuZQWN
         5ROFCer55KGa/fInyv76q06thmeuuQBk3mpco=
Date: Sat, 5 Jun 2010 23:01:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: hp_sdc_rtc: fix broken ioctl conversion
Message-ID: <20100605210142.GE5368@nowhere>
References: <201005241600.o4OG0QuA012887@hera.kernel.org> <AANLkTil7N3ZJclwotDQVt-8IYKudZ5mqPbyH906Cd4IJ@mail.gmail.com> <201006052252.21168.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201006052252.21168.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 05, 2010 at 10:52:21PM +0200, Arnd Bergmann wrote:
> Commit 55929332c92 "drivers: Push down BKL into various drivers"
> introduced a regression in hp_sdc_rtc, caused by a missing
> change of the .unlocked_ioctl pointer to the newly introduced
> function.
> 
> On Saturday 05 June 2010, Geert Uytterhoeven wrote:
> > Something went wrong with this one:
> > 
> > | drivers/input/misc/hp_sdc_rtc.c:681: warning: initialization from
> > incompatible pointer type
> > | drivers/input/misc/hp_sdc_rtc.c:665: warning:
> > ‘hp_sdc_rtc_unlocked_ioctl’ defined but not used
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
> index e00a1cc..c190664 100644
> --- a/drivers/input/misc/hp_sdc_rtc.c
> +++ b/drivers/input/misc/hp_sdc_rtc.c
> @@ -678,7 +678,7 @@ static const struct file_operations hp_sdc_rtc_fops = {
>          .llseek =		no_llseek,
>          .read =			hp_sdc_rtc_read,
>          .poll =			hp_sdc_rtc_poll,
> -        .unlocked_ioctl = 	hp_sdc_rtc_ioctl,
> +        .unlocked_ioctl =	hp_sdc_rtc_unlocked_ioctl,
>          .open =			hp_sdc_rtc_open,
>          .fasync =		hp_sdc_rtc_fasync,
>  };



Queued for .35, thanks!

