Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab2B2XvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:51:22 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58371 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2B2XvV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:51:21 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.175.36 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4EB0B9.2080906@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
	<CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
	<4F4C1F76.70403@zytor.com>
	<alpine.DEB.2.00.1202281927130.24649@be10.lrz>
	<4F4D1E6A.5000200@zytor.com>
	<CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
	<4F4E6B98.2090306@zytor.com>
	<CAKL7Q7o7udqrvKou=CSxuzJOuAJfemU4bizSsAtaebJZbBMRFQ@mail.gmail.com>
	<4F4EB0B9.2080906@zytor.com>
Date: Thu, 1 Mar 2012 00:51:20 +0100
Message-ID: <CAKL7Q7pq5BTax4odM5YuzR4TsoU5CV59341LziR9c=Yjnia4gQ@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/1 H. Peter Anvin <hpa@zytor.com>:
> Looks good, *except* that this will break the compile for all non-x86
> architectures.  It might be worthwhile to factor out the
> architecture-dependent bits for cleanliness.
>
>        -hpa
>


Will this work?

+#if (defined(__i386__) || defined(__x86_64__))
+#include <asm/io.h>
+#include <asm/setup.h>
+#else
+extern struct boot_params boot_params;
+#endif
