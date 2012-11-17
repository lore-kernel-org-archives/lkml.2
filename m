Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2KQAjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 19:39:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab2KQAjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 19:39:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121117002753.GA22778@kroah.com>
References: <20121117002016.GA13493@www.outflux.net> <20121117002753.GA22778@kroah.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sat, 17 Nov 2012 01:39:02 +0100
Message-ID: <CAPXgP12e5LpN6XVxaXOHhH=u8XXN==2reTaJDCoCk4tP4QduDQ@mail.gmail.com>
Subject: Re: [PATCH] devtmpfs: mount with noexec and nosuid
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        ellyjones@chromium.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2012 at 1:27 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Nov 16, 2012 at 04:20:16PM -0800, Kees Cook wrote:
>> Since devtmpfs is writable, make the default noexec nosuid as well. This
>> protects from the case of a privileged process having an arbitrary file
>> write flaw and an argumentless arbitrary execution (i.e. it would lack
>> the ability to run "mount -o remount,exec,suid /dev"), with a system
>> that already has nosuid,noexec on all other writable mounts.
>>
>> Cc: ellyjones@chromium.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/base/devtmpfs.c |    6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> Have you tested this to verify that it doesn't break anything?
>
> Kay, could this cause any problems that you could think of?

It breaks all sorts of old, possibly outdated, stuff, that does things
like mapping /dev/mem executable. It for sure used to break X drivers,
that fiddle with the BIOS of cards.

Kay
