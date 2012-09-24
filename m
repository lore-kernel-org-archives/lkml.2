Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab2IXNrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:47:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136Ab2IXNrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:47:11 -0400
Message-ID: <50606456.7020607@redhat.com>
Date: Mon, 24 Sep 2012 15:47:02 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dm-devel@redhat.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/1] dm-integrity: integrity protection device-mapper
 target
References: <cover.1348480396.git.dmitry.kasatkin@intel.com>
In-Reply-To: <cover.1348480396.git.dmitry.kasatkin@intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 11:55 AM, Dmitry Kasatkin wrote:
> Both dm-verity and dm-crypt provide block level integrity protection.

This is not correct. dm-crypt is transparent block encryption target,
where always size of plaintext == size of ciphertext.

So it can provide confidentiality but it CANNOT provide integrity protection.

We need extra space to store auth tag which dmcrypt cannot provide currently.

> dm-integrity provides a lighter weight read-write block level integrity
> protection for file systems not requiring full disk encryption, but
> which do require writability.

Obvious question: can be dm-verity extended to provide read-write integrity?

I would prefer to use standard mode like GCM to provide both encryption and
integrity protection than inventing something new.

Milan
