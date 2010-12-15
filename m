Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0LOTj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 14:39:56 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:61013 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab0LOTjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 14:39:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hl8qWyw0rfHahMvqxOPcyK81x3UclgW94LUzYA11/dvUv2bOJu7bd8pyDEpuayLdmc
         4YoD0CAHHREOUyL1yZxstY1wbT6WAvAfQi1dFSU7RH3alIe7Xr72mIZpt/QshsVCTJSF
         MhI5KbAaSaDcGNBiLfXoZSaDr8vcGYJ9NuaBs=
MIME-Version: 1.0
In-Reply-To: <4D08F825.3050206@gmail.com>
References: <4D08F825.3050206@gmail.com>
Date: Wed, 15 Dec 2010 17:39:41 -0200
Message-ID: <AANLkTinvsUJGLTFk0=vj=mMYS9ywa1XoF8Cj1r-eyCHn@mail.gmail.com>
Subject: Re: [PATCH] scripts: add no-warning option to the checkpatch script
From: Thiago Farina <tfransosi@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, apw@canonical.com,
        Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You probably wanted to copy Joe Perches too.

+Joe.

On Wed, Dec 15, 2010 at 3:17 PM, Marco Stornelli
<marco.stornelli@gmail.com> wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
>
> Add no-warning option to the checkpatch script.
>
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>
> --- linux-2.6.36-orig/scripts/checkpatch.pl     2010-10-20 22:30:22.000000000 +0200
> +++ linux-2.6.36/scripts/checkpatch.pl  2010-11-28 12:40:24.000000000 +0100
> @@ -15,6 +15,7 @@ my $V = '0.30';
>  use Getopt::Long qw(:config no_auto_abbrev);
>
>  my $quiet = 0;
> +my $chk_warn = 1;
>  my $tree = 1;
>  my $chk_signoff = 1;
>  my $chk_patch = 1;
> @@ -39,6 +40,7 @@ Version: $V
>
>  Options:
>   -q, --quiet                quiet
> +  --no-warning               do not report warnings
>   --no-tree                  run without a kernel tree
>   --no-signoff               do not check for 'Signed-off-by' line
>   --patch                    treat FILE as patchfile (default)
> @@ -65,6 +67,7 @@ EOM
>
>  GetOptions(
>        'q|quiet+'      => \$quiet,
> +       'warning!'      => \$chk_warn,
>        'tree!'         => \$tree,
>        'signoff!'      => \$chk_signoff,
>        'patch!'        => \$chk_patch,
> @@ -1087,7 +1090,7 @@ sub ERROR {
>        }
>  }
>  sub WARN {
> -       if (report("WARNING: $_[0]\n")) {
> +       if ($chk_warn && report("WARNING: $_[0]\n")) {
>                our $clean = 0;
>                our $cnt_warn++;
>        }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
