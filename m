Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1HDUg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 16:36:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7140 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1HDUgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 16:36:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 04 Aug 2011 13:36:12 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Len Brown <len.brown@intel.com>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 4 Aug 2011 13:35:59 -0700
Subject: next-200110804 ARM build break (cpuidle_call_idle)
Thread-Topic: next-200110804 ARM build break (cpuidle_call_idle)
Thread-Index: AcxS5PUpLnLFsJwSRC+9GUNkJGBpuA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With next-20110804, I'm seeing the following on ARM:

arch/arm/kernel/process.c: In function 'cpu_idle':
arch/arm/kernel/process.c:200: error: implicit declaration of function 'cpuidle_call_idle'

This was previously fixed with:

https://lkml.org/lkml/2011/4/4/109

Commit 5f8cf82 (cpuidle: stop using pm_idle) converted arches to use
cpuidle_idle_call() but contained typos on ARM and SH transposing the
function name into cpuidle_call_idle().

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

(which I think was included directly in linux-next according to that
email thread)

However, commit 5f8cf82 isn't in linux-next any more, but instead,
a0bfa13 "cpuidle: stop depending on pm_idle" has replaced it, and has
the same issue.

Applying Mark's previous fix solves the build problem.

Related, I see that linux-next merges
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git idle-test
yet that branch doesn't seem to exist anymore.

-- 
nvpublic

