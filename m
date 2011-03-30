Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681Ab1C3QOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 12:14:23 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53768 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1C3QOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 12:14:19 -0400
Message-Id: <20110330161322.015113054@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Wed, 30 Mar 2011 12:13:22 -0400
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: debora@linux.vnet.ibm.com, srajiv@linux.vnet.ibm.com,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc: jirislaby@gmail.com, preining@logic.at
Subject: [PATCH V2 00/12] tpm + tpm_tis : Various fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes various issues in the general TPM driver and the TPM TIS
driver. Some of the patches were previously posted, and are being re-posted
without change, while other patches were refactored. This patchset applies to
the tip of the main git tree.

Patches 1-6 are related to using the timeouts that the TPM reports, along with
work-arounds for TPMs that don't report the timeouts in microseconds but
rather in milliseconds.

Patch 7 fixes the display of the public key of the TPM's Endorsement Key in
sysfs.

Patch 8 re-enables the TPM's interrupts after resume from S3.

Patch 9 is useful if the TPM is run in interrupt mode and delays the S3 suspend
until the TPM has finished processing a command.

Patch 10 fixes several aspects of the code around the probing for interrupts.

Patch 11 introduces automatic probing for the Intel iTPM flaw. The probing
is useful in combination with the 'force' module parameter that enables
the interrupt mode on some machines but then ends up circumventing ACPI to
determine whether an Intel iTPM is present to activate the work-around. So,
in that case we can rely on the probing.

Patch 12 fixes a typo.

I have tested these patches on four different types of machines. They worked
fine there even though the TPM could not be used in interrupt mode on all of
them (IRQ line not connected?).

V2:
  - following Rajiv's feedback. Splitting the durations and timeout
    patches in 3 parts.
  - slightly rearranging the order of the patches

  Regards,
         Stefan
