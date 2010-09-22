Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab0IVRfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:35:01 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40881 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab0IVRe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:34:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=VIWu9Awg6+hNX8WWHg2jcTVQ/e2roNPVnOznZAGbS08CDDQGLOoQq2IUq+t18x0i3N
         j4nhXk4Fi9Ib8xc2JwxWkrg7wadmjPTyj2BjZioan7+VSl4SSADz1QGdkt51ZW6GRFP+
         ieMdgEGN5MOAr+M6a2sB1cORK++pjNyxnLNkw=
MIME-Version: 1.0
Date: Wed, 22 Sep 2010 11:34:58 -0600
Message-ID: <AANLkTi=RtK_w1a3dw=pM51M5sfqUtURsADG-+rdB-d=u@mail.gmail.com>
Subject: [BUG] Intermittent Keyboard Lockup 2.6.25.5 with debugger under heavy loads
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something changed between 2.6.35.1.  Under very heavy loads, I see the
keyboard loose interrupts and hang
when the scheduler is very busy.  Tracking it down.  Put a temp code
segment to read one of the keyboard
registers to clear previous pending interrupts.  The bug is the
keyboard gets a pending interrupt and never
services it.  Given the way the keyboard process is handled, looks
like a timing dependent scheduler bug
of some sort.

Jeff
