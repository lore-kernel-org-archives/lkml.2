Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145Ab0JZSqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 14:46:00 -0400
Received: from xenotime.net ([72.52.115.56]:38426 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753150Ab0JZSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 14:45:59 -0400
Date: Tue, 26 Oct 2010 11:45:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: docbook: fix fatal error in linux/input.h
Message-Id: <20101026114555.4b79977d.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recent commit 8613e4c2872a87cc309a42de2c7091744dc54d0e:
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Thu Sep 9 21:54:22 2010 -0700
    Input: add support for large scancodes

causes a fatal error in docbook generation:

linux-2.6.36-git8/DOC1/Documentation/DocBook/device-drivers.xml:40690: parser error : StartTag: invalid element name
#define INPUT_KEYMAP_BY_INDEX	(1 << 0)
                             	    ^

I think that this message comes from xsltproc, but I'm not positive about that.
I also don't know of a really good fix for it.  However, I did find 2 ways to
work around the error:

a/ move the #define value to after the end of the struct input_keymap_entry, like:

/* flags bits: */
#define INPUT_KEYMAP_BY_INDEX	(1 << 0)

or
b/ don't use the "<< 0" (can leave the #define where it is in this case):
#define INPUT_KEYMAP_BY_INDEX	(1)

I have tested both of these patches and they work OK.
Are you OK with either of them?  or want to choose one?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
