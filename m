Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab2LRQer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:34:47 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:63565 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab2LRQeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:34:44 -0500
MIME-Version: 1.0
Date: Tue, 18 Dec 2012 17:08:49 +0100
Message-ID: <CA+xc3O3TCCD4cabkoB2+yU-7Xe+VUzpOAyWPrhjZSXfecjxcOA@mail.gmail.com>
Subject: [ANNOUNCE] Kconfiglib: a flexible Python Kconfig parser and library -
 now on GitHub
From: Ulf Magnusson <ulfalizer.lkml2@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kconfiglib is a flexible Python Kconfig parser and library, first introduced in
https://lkml.org/lkml/2011/2/1/439. I have updated it for Linux 3.7.0 and put
it on GitHub at https://github.com/ulfalizer/Kconfiglib, making some
improvements in the process:

 - The installation has been simplified. No need to copy anything anywhere now,
   and just a trivial single-block Makefile patch to apply. (The patch adds a
   few convenient make targets that also help us pick up ARCH, SRCARCH, and
   KERNELVERSION from the environment.)

 - The API has been cleaned up and made more consistent by renaming a few
   functions.

 - The entire API is now covered by an extensive suite of selftests in addition
   to the automatic compatibility tests.

The only failures in the test suite as of 3.7.0 (848b81415c42ff) are due to a
bug that makes scripts/kconfig/conf generate an incorrect configuration for
some Blackfin defconfigs (https://lkml.org/lkml/2012/12/5/458). This causes
failures in the Kconfiglib test suite since it automatically compares the
output from Kconfiglib with that from scripts/kconfig/conf and Kconfiglib does
not have the same bug.

Note: I do not have plans to get this into the kernel.

Feedback welcome!
/Ulf
