Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0IJRhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:37:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:64848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab0IJRhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:37:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,347,1280732400"; 
   d="scan'208";a="553386620"
From: "Hoban, Adrian" <adrian.hoban@intel.com>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Sep 2010 18:37:02 +0100
Subject: [PATCH 0/3] Optimized RFC4106 AES-GCM implementation using Intel
 New Instructions
Thread-Topic: [PATCH 0/3] Optimized RFC4106 AES-GCM implementation using
 Intel New Instructions
Thread-Index: ActRDd6HBCAhtkpuQt+GkP0vFbF4LQ==
Message-ID: <CFBC532374C38D45810FA00BC2D2C2040120CA815B@irsmsx502.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Bw74 Bzwm DWmN GO2f G5uy Hhbe JDkh JOY3 Jw6Y KjkW LJHn
 NNnh QmX1 SjCQ SyiW
 Y7AE;3;aABlAHIAYgBlAHIAdABAAGcAbwBuAGQAbwByAC4AYQBwAGEAbgBhAC4AbwByAGcALgBhAHUAOwBsAGkAbgB1AHgALQBjAHIAeQBwAHQAbwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{15EC0662-802B-41A1-A3FF-D6191700D4C5};YQBkAHIAaQBhAG4ALgBoAG8AYgBhAG4AQABpAG4AdABlAGwALgBjAG8AbQA=;Fri,
 10 Sep 2010 17:30:58
 GMT;WwBQAEEAVABDAEgAIAAwAC8AMwBdACAATwBwAHQAaQBtAGkAegBlAGQAIABSAEYAQwA0ADEAMAA2ACAAQQBFAFMALQBHAEMATQAgAGkAbQBwAGwAZQBtAGUAbgB0AGEAdABpAG8AbgAgAHUAcwBpAG4AZwAgAEkAbgB0AGUAbAAgAE4AZQB3ACAASQBuAHMAdAByAHUAYwB0AGkAbwBuAHMA
x-cr-puzzleid: {15EC0662-802B-41A1-A3FF-D6191700D4C5}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This set of patches adds an optimized RFC4106 AES-GCM implementation for 64-bit kernels and 128-bit AES keys. It supports processors based on the Intel(r) microarchitecture codename Westmere, such as the Intel(r) Xeon(r) 5600 processor family.

The code leverages the crypto AEAD interface type to facilitate a combined AES & GCM operation to be implemented in a unified block of assembly code. The assembly code leverages Intel(r) AES New Instructions and the carry-less multiple PCLMULQDQ instruction which were introduced on the Intel(r) microarchitecture codename Westmere.

The first patch is an update to the cryptd framework to add support for the AEAD interface type.
The second patch is the RFC4106 AES-GCM Crypto Driver & Assembly Code. 
The third patch is an update to crypto self-test code to extend AES-GCM tests.

For more information on the patches, the assembly code design, and on some performance results please reference these papers:
Using Intel(r) AES New Instructions and PCLMULQDQ to Significantly Improve IPSec Performance on Linux: http://download.intel.com/design/intarch/papers/324238.pdf
Optimized Galois-Counter-Mode Implementation on Intel(r) Architecture Processors: http://download.intel.com/design/intarch/PAPERS/324194.pdf

Regards,
Adrian Hoban
--------------------------------------------------------------
Intel Shannon Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263
Business address: Dromore House, East Park, Shannon, Co. Clare

This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). Any review or distribution by others is strictly prohibited. If you are not the intended recipient, please contact the sender and delete all copies.


