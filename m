Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab1ECV6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 17:58:32 -0400
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:44476 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751065Ab1ECV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 17:58:31 -0400
Date: Tue, 3 May 2011 23:58:29 +0200
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        linux list <linux-kernel@vger.kernel.org>
Subject: Re: regulators: kzalloc doubt
Message-ID: <20110503215828.GJ5352@nuttenaction>
References: <BANLkTik4bW7nRMFXKW-UpfrSsaimEQ=zWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik4bW7nRMFXKW-UpfrSsaimEQ=zWg@mail.gmail.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thiago Farina | 2011-05-03 18:54:13 [-0300]:

>What is the preferred way to use kzalloc? I have seen two ways under
>drivers/regulator/.
>
>1-
>
>struct my_regulator_info *info = NULL;
>
>info = kzalloc(sizeof(struct my_regulator_info), GFP_KERNEL);
>
>2-
>
>struct my_regulator_info *info;
>
>info = kzalloc(sizeof(*info), GFP_KERNEL);

Documentation/CodingStyle - Chapter 14: Allocating memory:


	 [...] 
	 The preferred form for passing a size of a struct is the following:
	 
		 p = kmalloc(sizeof(*p), ...);
	 
	 The alternative form where struct name is spelled out hurts readability and
	 introduces an opportunity for a bug when the pointer variable type is changed
	 but the corresponding sizeof that is passed to a memory allocator is not.
	 
	 Casting the return value which is a void pointer is redundant. The conversion
	 from void pointer to any other pointer type is guaranteed by the C programming
	 language.


Cheers, Hagen
