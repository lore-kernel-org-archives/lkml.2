Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2KUASf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:18:35 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33828 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab2KUASe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:18:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP126a0Wqw2NtkAAo6eqd1tvQyjLE0Kh=de3Cs2bd90K+8g@mail.gmail.com>
References: <20121120204238.GA19554@www.outflux.net>
	<CAPXgP126a0Wqw2NtkAAo6eqd1tvQyjLE0Kh=de3Cs2bd90K+8g@mail.gmail.com>
Date: Tue, 20 Nov 2012 16:18:33 -0800
X-Google-Sender-Auth: g1OMruitIqjSgMCEOFN_QNVnQEI
Message-ID: <CAGXu5jK5VWU8qxOAsrhSMrrdDaZVpLJWw0dQk3newvUK56rzVw@mail.gmail.com>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
From: Kees Cook <keescook@chromium.org>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Roland Eggner <edvx1@systemanalysen.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 4:13 PM, Kay Sievers <kay@vrfy.org> wrote:
> On Tue, Nov 20, 2012 at 9:42 PM, Kees Cook <keescook@chromium.org> wrote:
>> Since devtmpfs is writable, make the default noexec,nosuid as well. This
>> protects from the case of a privileged process having an arbitrary file
>> write flaw and an argumentless arbitrary execution (i.e. it would lack
>> the ability to run "mount -o remount,exec,suid /dev").
>
> This only really applies to systems without an initramfs when the
> kernel mounts /dev over the rootfs it has mounted; with an initramfs,
> /dev is always mounted by user code.
>
> Just checking, that is the use case you are doing that for?

Correct. We're using this in Chrome OS, which does not use an initramfs.

-Kees

-- 
Kees Cook
Chrome OS Security
