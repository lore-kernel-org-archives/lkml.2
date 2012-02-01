Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2BAHMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 02:12:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33408 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2BAHMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 02:12:07 -0500
MIME-Version: 1.0
Date: Wed, 1 Feb 2012 15:12:06 +0800
Message-ID: <CANudz+snKSchS6yY8+w9GyogcwstEEAopmESJbLs=hkCSJo5XA@mail.gmail.com>
Subject: Some question about "security context of a task"
From: loody <miloody@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all:
I found there is a user_struct, user, located at struct cred.
is it possible be null?
My platform sometimes panic when using kernel_thread to creating a
thread for running.

below is the place it happen

if (atomic_read(&p->real_cred->user->processes) >=
             p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
after checking the parameter, I found p->real_cred->user is NULL.

When and how we allocate/destroy this parameter?
Does that mean we should some basic check before calling kernel_thread?

-- 
Regards,
