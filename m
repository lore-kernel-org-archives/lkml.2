Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030528Ab2HPVU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:20:58 -0400
Received: from mga05.intel.com ([192.55.52.89]:4100 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030496Ab2HPVUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:20:55 -0400
MIME-Version: 1.0
Date: Fri, 17 Aug 2012 00:20:53 +0300
Message-ID: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
Subject: on stack dynamic allocations
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: herbert@gondor.hengli.com.au
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Some places in the code uses variable-size allocation on stack..
For example from hmac_setkey():

	struct {
		struct shash_desc shash;
		char ctx[crypto_shash_descsize(hash)];
	} desc;


sparse complains

CHECK   crypto/hmac.c
crypto/hmac.c:57:47: error: bad constant expression

I like it instead of kmalloc..

But what is position of kernel community about it?

- Dmitry
