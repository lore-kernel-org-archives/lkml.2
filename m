Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935696Ab0EVB2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 21:28:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50437 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0EVB2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 21:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=cFrNc8+1rpr2SUa1kOW6XlUzcOme/PUOMlpH6WWMjsxDey/Mlu1ENtk/HCjNQn4kK5
         EUCMB9ZqWWdtbz9tePIeaKBry9comGMJKPDXCie85ksMNrhzdiM5JeVhwGn7ApBIRhI6
         iBQrZkpZh0bzokASlW1YPvhTFMO8kYwtnyISk=
MIME-Version: 1.0
In-Reply-To: <1274489059-1019-1-git-send-email-lrodriguez@atheros.com>
References: <1274489059-1019-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 21 May 2010 18:28:19 -0700
X-Google-Sender-Auth: BjGpHXniY2-47aHjT62NEBGuw48
Message-ID: <AANLkTinAydFcFSOK7D7T7_gQsghiYwW1bp4DNloyTAcJ@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: add linux-next-pending, crap patch dirs 
	and nagometer
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 5:44 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Sometimes you have no other option but to carry around patches.
> This can happen for a variety of reasons. Ultimately testing of code
> cannot happen on the kernel maintainer's clock but on your own.
>
> This expands the idea of the linux-next-cherry-pick patch directory
> on compat-wireless to also allow for patches to be merged which are
> posted to some mailing list but pending merge due to some reasons
> (merge window is a good example). It also adds a crap patch directory
> for those really nasty situations you can run into where you have
> no other option but to give someone a release with some delta even
> if the patch is not yet posted anywhere.
>
> The focus should always be upstream though so to avoid these
> situations we will also provide code metrics to indicate to
> the package maintainer how much code came from each directory,
> including the backport code to support older kernel releases.
>
> Maybe we should add the code-metrics.txt file as a print out
> on the compat module load :)
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

So this is what I get with what I just merged and using -p -c

compat-wireless code metrics

    497275 - Total upstream code being pulled
      1393 - backport code changes
      1163 - backport code additions
       230 - backport code deletions
      0.28 - % of code consists of backport work
      6856 - Code changes posted but not yet merged
      4412 - Code additions posted but not yet merged
      2444 - Code deletions posted but not yet merged
      1.38 - % of code not yet merged
      1225 - Crap changes not yet posted
      1181 - Crap additions not yet merged
        44 - Crap deletions not yet posted
      0.25 - % of crap code

Base tree: linux-next.git
Base tree version: next-20100518
compat-wireless release: compat-wireless-20100521-3-g0935025

The 1.38% is code Atheros has posted but is not yet merged. By default
this code is not merged into the bleeding edge compat-wireless
releases.

Usage: ./scripts/admin-update.sh [ refresh] [ --help | -h | -n | -p | -c ]
   refresh - will update your all your patch offsets using quilt
        -n - apply the patches linux-next-cherry-picks directory
        -p - apply the patches on the linux-next-pending directory
        -c - apply the patches on the crap directory

In case it helps with the delay of the merge window feel free to send
me patches which are pending and you do think are important for
existing testing with the bleeding edge linux-next codebase. I am in
hopes as a side effect maybe this could help John and/or Marcel
*after* the merge window when they have to merge stuff for the next
release cycle.

  Luis
