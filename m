Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2BGE4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 23:56:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36623 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab2BGE4V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 23:56:21 -0500
MIME-Version: 1.0
In-Reply-To: <20120207041958.GA32377@bombadil.infradead.org>
References: <1328312594-31934-1-git-send-email-mcgrof@frijolero.org>
 <20120206160727.GA21048@tuxdriver.com> <20120207041958.GA32377@bombadil.infradead.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 6 Feb 2012 20:56:01 -0800
X-Google-Sender-Auth: F952LqZ2h5p5kc3wgN-U_DQcKmY
Message-ID: <CAB=NE6VS79S4R6wQddQCqPfoYPyRbPzSdAYN2Mxfi-4G_sfCvg@mail.gmail.com>
Subject: Re: [PATCH] compat: add compat kernel checker and downloader
To: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, hauke@hauke-m.de,
        kernel-team@lists.ubuntu.com, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 8:19 PM, Luis R. Rodriguez
<mcgrof@bombadil.infradead.org> wrote:
> On Mon, Feb 06, 2012 at 11:07:28AM -0500, John W. Linville wrote:
>> On Fri, Feb 03, 2012 at 03:43:14PM -0800, Luis R. Rodriguez wrote:
>> > This adds get-compat-kernels, a utility that is intended
>> > to be Linux distribution agnostic that downloads and installs
>> > all kernel headers for all supported kernel releases of compat.
>> > You also have the option of specifying you want to also install
>> > the actual kernel image (get-compat-kernels -i).
>> >
>> > We start off by adding support for Ubuntu on x86_64 as that
>> > is what a few of us maintaining compat and compat-wireless run.
>> > Just for kernel headers (default run of get-compat-kernels),
>> > you'll need currently 205 M of hard drive space.
>> >
>> > Once done with running get-compat-kernels, you can then
>> > start running ckmake to verify your compat kernel changes
>> > won't bust compilation against any known supported kernel.
>> >
>> > I'd like to start requiring runs against this script for
>> > patch submissions. Eventually we can try to add the same
>> > runs against compat-wireless so we can verify integrity
>> > against compilation for different kernel versions.
>> >
>> > Support for different Linux distributios is welcomed.
>> >
>> > Debug log goes out to ckmake.log
>> >
>> > Example output:
>> >
>> > mcgrof@tux ~/compat (git::master)$ ckmake
>> > Trying kernel                  3.3.0-030300rc2-generic  [OK]
>> > Trying kernel                     3.2.2-030202-generic  [OK]
>> > Trying kernel                    3.1.10-030110-generic  [OK]
>> > Trying kernel                    3.0.18-030018-generic  [OK]
>> > Trying kernel                  2.6.39-02063904-generic  [OK]
>> > Trying kernel                         2.6.38-8-generic  [OK]
>> > Trying kernel                        2.6.38-13-generic  [OK]
>> > Trying kernel                        2.6.38-12-generic  [OK]
>> > Trying kernel                        2.6.38-11-generic  [OK]
>> > Trying kernel                        2.6.38-10-generic  [OK]
>> > Trying kernel                  2.6.38-02063808-generic  [OK]
>> > Trying kernel                  2.6.37-02063706-generic  [OK]
>> > Trying kernel                  2.6.36-02063604-generic  [OK]
>> > Trying kernel                  2.6.35-02063512-generic  [OK]
>> > Trying kernel                  2.6.34-02063410-generic  [OK]
>> > Trying kernel                  2.6.33-02063305-generic  [OK]
>> > Trying kernel                  2.6.32-02063255-generic  [OK]
>> > Trying kernel                        2.6.31-22-generic  [OK]
>> > Trying kernel                  2.6.31-02063113-generic  [OK]
>> > Trying kernel                  2.6.30-02063010-generic  [OK]
>> > Trying kernel                  2.6.29-02062906-generic  [OK]
>> > Trying kernel                  2.6.28-02062810-generic  [OK]
>> > Trying kernel                    2.6.27-020627-generic  [OK]
>> > Trying kernel                    2.6.26-020626-generic  [OK]
>> > Trying kernel                    2.6.25-020625-generic  [OK]
>> > Trying kernel                    2.6.24-020624-generic  [OK]
>> >
>> > Cc: kernel-team@lists.ubuntu.com
>> > Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
>>
>> I'm not sure this makes any sense.  I thought the point of the compat
>> project was to support upstream kernels, not distro ones?
>
> Absolutely but distributions also build kernels for us so if we're lazy
> we don't have to do anything but just install some sort of package.
> The get-compat-kernels takes advantage of this fact and lists a way
> to let us get all known supported kernels from Ubuntu's PPA repository
> that has mainline kernels. That is, these are kernels from mainline
> without any Ubuntu jazz on it.
>
>> I'm not
>> even sure I know how to replicate the above process in Fedora, since
>> we would only have kernels available from a given release in each
>> release's repository.
>
> The Ubuntu PPA was special, it was put in place to help users tests
> kernel issues on a mainline kernel without any ubuntu jazz when
> there were concerns that perhaps the issues on bugzilla.kernel.org
> may have been cause by some of the deltas.
>
> The scripts can be explanded to use general kernels though:
>
> diff --git a/bin/ckmake b/bin/ckmake
> index 4d45fb9..3b49347 100755
> --- a/bin/ckmake
> +++ b/bin/ckmake
> @@ -34,8 +34,11 @@ case $LSB_RED_ID in
>        done
>        ;;
>  *)
> -       echo -e "Unsupported distribution"
> -       exit
> +       for i in $(find /lib/modules/ -type d | sort -n -r); do
> +               if [[ -d $i/build/ && -f $i/build/Makefile ]]; then
> +                       KLIBS="$KLIBS $i"
> +               fi
> +       done
>        ;;
>  esac
>
> diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
> index 07ac17b..9bb9f39 100755
> --- a/bin/get-compat-kernels
> +++ b/bin/get-compat-kernels
> @@ -148,7 +148,14 @@ case $LSB_RED_ID in
>        get_ubuntu_kernels
>        ;;
>  *)
> -       echo -e "Unsupported distribution"
> -       exit
> +       echo -e "Using your available kernels. We recommend to have "
> +       echo -e "all supported asupported kernels listed on kernel.org."
> +       echo -e "Currently our target is to at least support all kernels "
> +       echo -e "in the range 2.6.27 - 3.3. You have:\n":
> +       for i in $(find /lib/modules/ -type d | sort -n -r); do
> +               if [[ -d $i/build/ && -f $i/build/Makefile ]]; then
> +                       echo -e " * $(basename $i))"
> +               fi
> +       done
>        ;;
>  esac
>
>
> This could be improved to ensure that ckmake will not run for any
> case unless at least one kernel for each suppoted kernel release is
> present to test.
>
> Thoughts?

Come to think of it.. we could bastardize Ubuntu's PPA packages for
mainline kernels, translate the deb packages into tar files and some
sort of grub-update or whatever scrip to run in the end? That still
seems like a lot of work.

The current option allows us to use either distro kernels or whatever
you have installed.. not sure how else to improve this. Didn't we have
some sort of distro agnostic package crap? Maybe?

  Luis
