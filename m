Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1H1NRP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 09:17:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40264 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab1H1NRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 09:17:10 -0400
Message-ID: <4E5A3FCC.2030504@gnutls.org>
Date: Sun, 28 Aug 2011 15:17:00 +0200
From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: cryptodev-linux-devel@gna.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: comparison of the AF_ALG interface with the /dev/crypto
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I've compared the cryptodev [0] and AF_ALG interfaces in terms of
performance [1]. I've put the results, as well as the benchmarks used
in: http://home.gna.org/cryptodev-linux/comparison.html

The benchmark idea was to test the speed of initialization, encryption
and deinitiation, as well as the encryption speed alone. These are the
most common use cases of the frameworks (i.e. how they would be used by 
a cryptographic library).

The AF_ALG appears to have poor performance comparing to cryptodev. Note
that the test with software AES is not really indicative because the
cost of software encryption masks the overhead of the framework. The
difference is clearly seen in the NULL cipher that has no cost (as one
would expect from a hardware cipher accelerator).

Given my benchmarks have no issues, it is not apparent to me why one
should use AF_ALG instead of cryptodev. I do not know though why AF_ALG
performs so poor. I'd speculate by blaming it on the usage of the socket
API and the number of system calls required.

regards,
Nikos

[0]. http://home.gna.org/cryptodev-linux/
[1]. Both intend to provide user-space with high-bandwidth hardware 
accelerated ciphers, thus performance seems a rational to compare.
