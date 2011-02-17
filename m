Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab1BQRpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:45:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63333 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab1BQRpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:45:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 05/12] unicore32 additional architecture files: low-level lib: uaccess
Date: Thu, 17 Feb 2011 18:45:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <014b01cbcdad$f110afb0$d3320f10$@mprc.pku.edu.cn>
In-Reply-To: <014b01cbcdad$f110afb0$d3320f10$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171845.01177.arnd@arndb.de>
X-Provags-ID: V02:K0:Vtk6XKtpdd2EY/upTlIEh+9yK0PBBydOHPuYxih4l5g
 Ifcn0phAY/h2JnGZUrCtakhuuqrg1tn5aWyYWa/hrWLERZU2pq
 i4dLL+ViKwN6hdu6PS2e/bXo3oicNkHsLLJJJylaxAicdEHw2H
 GgBt2+s7UT3MTYDOBCoI/JtQ9vrCFhzrQS99UxPEc8KzvRqPXr
 n7GelyFLqMr49a0mVzRtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 February 2011, Guan Xuetao wrote:
> +
> +#define __kernel_ok		(segment_eq(get_fs(), KERNEL_DS))
> +#define __user_ok(addr, size)	(((size) <= TASK_SIZE)			\
> +				&& ((addr) <= TASK_SIZE - (size)))
> +#define __access_ok(addr, size)	(__kernel_ok || __user_ok((addr), (size)))

A nice trick to simplify this is to introduce a per-process variable for comparing
the pointer, set_fs() then sets this variable to either TASK_SIZE or
UINT_MAX.

This saves one conditional branch for each call to __access_ok.

	Arnd
