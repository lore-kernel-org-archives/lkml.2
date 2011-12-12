Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab1LLXpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:45:01 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:52311 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752023Ab1LLXo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:44:56 -0500
Message-ID: <1323733493.1812.10.camel@joe2Laptop>
Subject: drivers/crypto/picoxcell_crypto.c: boolean and / or confusion
From: Joe Perches <joe@perches.com>
To: roel <roel.kluin@gmail.com>, Jamie Iles <jamie@jamieiles.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Date: Mon, 12 Dec 2011 15:44:53 -0800
In-Reply-To: <4EE688FC.8090606@gmail.com>
References: <4EE688FC.8090606@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
> The test not [val1] or not [val2] always evaluates to true

Hey Jamie and Roel

Looking at drivers with:

$ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\|\|\s*\1\s*\!\=" drivers

drivers/crypto/picoxcell_crypto.c:	if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&
drivers/crypto/picoxcell_crypto.c:	} else if ((len != AES_KEYSIZE_128 || len != AES_KEYSIZE_256) &&

Most likely these should be && not ||.

