Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1F3U65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 16:58:57 -0400
Received: from acheron.ifi.lmu.de ([129.187.214.135]:51577 "EHLO
	acheron.ifi.lmu.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1F3U6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 16:58:55 -0400
X-Greylist: delayed 1708 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jun 2011 16:58:55 EDT
From: Michael Brade <brade@informatik.uni-muenchen.de>
Organization: =?iso-8859-1?q?Ludwig-Maximilians-Universit=E4t?= 
 =?iso-8859-1?q?_M=FCnchen?=
To: linux-kernel@vger.kernel.org
Subject: found the reason for: utsrelease.h contains "CHK include/generated/utsrelease"
Date: Thu, 30 Jun 2011 22:30:25 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39.2-grsec+; KDE/4.6.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106302230.25239.brade@informatik.uni-muenchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I repeatedly get garbled output in utsrelease.h when compiling my own
> kernel. 
> To reproduce:
>
> make mrproper
> make allnoconfig
> make prepare
>
> Output of "cat include/generated/utsrelease.h":
>  CHK     include/generated/utsrelease

I have spent many more hours analyzing this and finally found exactly what 
causes this problem: doing "make prepare" under a running kernel with the 
grsecurity/PAX option CONFIG_PAX_MEMORY_UDEREF set to Yes. I will post this in 
the grsecurity forums as well, it seems to be their bug after all.

cheers,
  Michael 


