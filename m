Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab1IBL1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 07:27:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58544 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1IBL1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 07:27:18 -0400
MIME-Version: 1.0
Date: Fri, 2 Sep 2011 16:57:17 +0530
Message-ID: <CADDb1s1A38RyioiehzbRCgjFQT-MhfoD7cutxkn+h_cvUcZpfg@mail.gmail.com>
Subject: =?windows-1252?Q?vfat_filesystem=3A_Why_utf8=3D1_when_iocharset=3D=94utf8?=
	=?windows-1252?Q?=94_was_already_there=3F?=
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linkinjeon@gmail.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From my opinion both should support the same functionality as the
motive behind this seems to introduce the complete support for utf8.
But, I am surprised to see the behavior changes in the ‘2’ options.
1)	When using iocharset=”utf8” it makes vfat case sensitive, while
this is not the case with using utf8=1
2)	Surrogate pair don’t work when using iocharset=”utf8”, because that
traverses a path like this:
xlate_to_uni()-->nls->char2uni()-->char2uni()-->utf8_to_utf32()
After this it returns EINVAL because Surrogate pair correct code is
greater than 0xFFFF (MAX_WCHAR_T – limit which is put)
But this is not the case with utf8=1
There are other places also where I can see usage different due to
usage of char2uni()

Can someone provide any help on this? Why do we have separate options
for using utf8 and if utf8=1 smoothly supports proper working then why
not discard iocharset=”utf8” ? and if this is not the case
why was utf8=1 introduced?

Please provide any guidance in this.

Thanks & Regards,
Amit Sahrawat
