Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761247Ab0FRNPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 09:15:38 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56460 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab0FRNPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 09:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U5THxHc83iw7I/ow89br8nmoucXWvWmZT7AnntLsg1t7bkNLyEhbMVBnBTCYQmRaje
         UFnElzhNexz75Snx3fjz79Va1pJo7g615idAECWKsJGEiyEqIzouk8IZeQBjv8tv2FDv
         cheVAiI1MaNf3zFuUxE+3xrw3+jNLtPBEO0EE=
MIME-Version: 1.0
In-Reply-To: <1276806411-15176-1-git-send-email-scottjg@vmware.com>
References: <1276806411-15176-1-git-send-email-scottjg@vmware.com>
Date: Fri, 18 Jun 2010 14:15:35 +0100
X-Google-Sender-Auth: -VUVPLyM1GdGr8_gM6vV_RrpxMQ
Message-ID: <AANLkTilrWSOoias64UGAnkV1RtIkVKiwapCnOYc2cS0_@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: fix false positive on casting to double 
	pointer
From: Andy Whitcroft <apw@canonical.com>
To: "Scott J. Goldman" <scottjg@vmware.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 9:26 PM, Scott J. Goldman <scottjg@vmware.com> wrote:
>
> Signed-off-by: Scott J. Goldman <scottjg@vmware.com>
> ---
>  scripts/checkpatch.pl         |    4 +++-
>  tests/t/t9190-double-pointers |    6 ++++++
>  2 files changed, 9 insertions(+), 1 deletions(-)
>  create mode 100644 tests/t/t9190-double-pointers
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 87bbb8b..687bd6f 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1982,7 +1982,9 @@ sub process {
>                                         $op eq '*' or $op eq '/' or
>                                         $op eq '%')
>                                {
> -                                       if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
> +                                       if ($op eq '*' && $cc =~ /^\*/) {
> +                                               # double pointer is ok
> +                                       } elsif ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
>                                                ERROR("need consistent spacing around '$op' $at\n" .
>                                                        $hereptr);

Hrm, I would expect any number of levels of pointers to be detected
already correctly.

/me goes check.

-apw
