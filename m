Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab1HOFKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:10:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43669 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1HOFKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:10:39 -0400
MIME-Version: 1.0
In-Reply-To: <1313384834-24433-12-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
	<1313384834-24433-12-git-send-email-lacombar@gmail.com>
Date: Mon, 15 Aug 2011 01:10:38 -0400
Message-ID: <CACqU3MVUU-PcPurOa5Fca2oEjpJXGpQj5AjAMQVUK_uQcVxCTg@mail.gmail.com>
Subject: Re: [PATCH 11/11] script/checkpatch.pl: warn about deprecated use of EXTRA_{A,C,CPP,LD}FLAGS
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[of course, I forgot to sign them :(]

On Mon, Aug 15, 2011 at 1:07 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Usage of these flags has been deprecated for nearly 4 years by:
>
>    commit f77bf01425b11947eeb3b5b54685212c302741b8
>    Author: Sam Ravnborg <sam@neptun.(none)>
>    Date:   Mon Oct 15 22:25:06 2007 +0200
>
>        kbuild: introduce ccflags-y, asflags-y and ldflags-y
>
> Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
> line use. By default, gmake(1) do not override command line setting, so this is
> likely to result in build failure or unexpected behavior.
>
> Warn about their introduction in Makefile or Kbuild files.
>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>

 - Arnaud

> ---
>  scripts/checkpatch.pl |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 9d761c9..955183a 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1661,6 +1661,20 @@ sub process {
>                        #print "is_end<$is_end> length<$length>\n";
>                }
>
> +               if (($realfile =~ /Makefile.*/ || $realfile =~ /Kbuild.*/) &&
> +                   ($line =~ /\+(EXTRA_[A-Z]+FLAGS).*/)) {
> +                       my $flag = $1;
> +                       my $replacement = {
> +                               'EXTRA_AFLAGS' =>   'asflags-y',
> +                               'EXTRA_CFLAGS' =>   'ccflags-y',
> +                               'EXTRA_CPPFLAGS' => 'cppflags-y',
> +                               'EXTRA_LDFLAGS' =>  'ldflags-y',
> +                       };
> +
> +                       WARN("DEPRECATED_VARIABLE",
> +                            "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
> +               }
> +
>  # check we are in a valid source file if not then ignore this hunk
>                next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
>
> --
> 1.7.6.153.g78432
>
>
