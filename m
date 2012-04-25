Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab2DYVZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:25:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40844 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab2DYVY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:24:59 -0400
MIME-Version: 1.0
Date: Wed, 25 Apr 2012 14:24:59 -0700
Message-ID: <CAMe9rOrjNZB1K0rxR+m0WeYqptxyq33A5vwzzA7c350XtyXPXA@mail.gmail.com>
Subject: BITS_PER_LONG used in include/asm-generic/statfs.h
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

include/asm-generic/statfs.h has

#ifndef __statfs_word
#if BITS_PER_LONG == 64
#define __statfs_word long
#else
#define __statfs_word __u32
#endif
#endif

however, BITS_PER_LONG isn't defined when asm-generic/statfs.h is exported to
user space.  Shouldn't it check __BITS_PER_LONG instead, at least when
exported to user space?

-- 
H.J.
