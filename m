Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1BYJTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:19:30 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:11285 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932222Ab1BYJT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:19:29 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Feb 2011 04:19:28 EST
Subject: termios and console cflag problems (on uart) with suspend/resume
From: Wireen <lars.wireen@sonyericsson.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 10:09:25 +0100
Message-ID: <1298624965.10694.19.camel@seldlx2931.corpusers.net>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I have understood it when resume is done the cflag from the console
is being used to reinitialize the uart unless a userspace process has
opened the uart in which case the termios setting is being used. This
seem to have been done by resetting the cflag for the console and in
that case use the termios settings. However it looks (to me) that when
the userspace process closes the uart the termios settings will be gone
(and the cflag for the console is gone too), this will make the
suspend/resume not being able to restore the uart settings (which in
turn means that kernel logging to uart will stop working after suspend).

Have I missed something (ie is it supposed to work in another way?) or
is this an intensional behavior?

