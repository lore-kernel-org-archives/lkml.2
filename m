Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759565Ab0FJSFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:05:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61063 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab0FJSFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=URRbBnjbYZRRThbiuJfhlphzf4ytu2eeKqBOjTwFk+7O3yuOSysBrS3BmMS+Cl39Gg
         SQlTKZgU+ACnKxh+nEhB+P3hShibUTJ1ETTuRc7FXAEKPa/ndcx7GEW1XxhGzmZF8QGQ
         xRQ9M3FHkzKZmh6ugyYts90Dw+zlFG3iX1XZ8=
MIME-Version: 1.0
Date: Thu, 10 Jun 2010 11:05:09 -0700
Message-ID: <AANLkTimw2Hzv1WIJXehqMo4450ftRJWwefQipDM9Zxb4@mail.gmail.com>
Subject: PROBLEM: Off-by-one bug on sun4u SMP
From: Ryan Davis <iconoclasmandheresy@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On at least some sun4u machines, the CPU numbering starts at one not 0.
This causes an off-by-one bug as other parts of the code assume
zero-based numbering.

If you set max-cpus in the kernel config to the actual number of CPUs,
the last CPU will be ignored and unused.
This is because the CPU numbering starts at 1 but the code to check
against max-cpus assumes a zero-based numbering.

On my computer: Sun Ultra 60 2x450mhz Ultrasparc.
Building with max-cpus of 2 ignores the second cpu because 2 (one
based cpu number) >= 2 (zero based max cpus)
Rebuilding with a larger max-cpus is a workaround but non optimal.
---
Those who will not reason, are bigots, those who cannot, are fools,
and those who dare not, are slaves.
 -- Lord Byron
