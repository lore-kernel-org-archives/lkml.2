Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0KXUWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 15:22:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43086 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab0KXUWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 15:22:51 -0500
Subject: PID_MAX_LIMIT limit on ia32?
From: Davy Durham <ddurham@davyandbeth.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 14:22:37 -0600
Message-ID: <1290630157.14831.226.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have searched around without a definitive answer to my question.

PID_MAX_LIMIT is currently defined as:

        /*
         * A maximum of 4 million PIDs should be enough for a while.
         * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see
futex.h.]
         */
        #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 :
(sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
        

And PID_MAX_DEFAULT is normally 32k.

I found a comment on the net:

        “When recycling PID numbers, the kernel must manage a
        pidmap_array bitmap that denotes which are the PIDs currently
        assigned and which are the free ones. Because a page frame
        contains 32,768 bits, in 32-bit architectures the pidmap_array
        bitmap is stored in a single page. In 64-bit architectures,
        however, additional pages can be added to the bitmap when the
        kernel assigns a PID number too large for the current bitmap
        size. These pages are never released.”


Which may seem to indicate that PID_MAX_DEFAULT cannot be more than 1
memory page on 32bit archs.

Can the PID_MAX_LIMIT #define be increased safely on the ia32 arch which
would cause pidmap_array to use more than one memory page?  (say 4 pages
or so).

I thought about just compiling it and testing things, but was unsure if
I would run into problems long-term.

[Please CC me on the response as I'm not currently subscribed]

TIA,
  Davy

