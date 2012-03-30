Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760851Ab2C3NPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:15:02 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35088 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760735Ab2C3NOy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:14:54 -0400
MIME-Version: 1.0
In-Reply-To: <3e80acd1af40fcd91a200b0416a7616b20c5d647.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
	<1333102459-23750-1-git-send-email-lenb@kernel.org>
	<3e80acd1af40fcd91a200b0416a7616b20c5d647.1333101989.git.len.brown@intel.com>
Date: Fri, 30 Mar 2012 09:14:53 -0400
Message-ID: <CA+5PVA4EBdoxgSrYKYRnaO2qSXDP_rxeQEogD+6jkKPi8sQB-g@mail.gmail.com>
Subject: Re: [PATCH 04/76] ACPICA: Fix regression in FADT revision checks
From: Josh Boyer <jwboyer@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Len Brown <len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 6:13 AM, Len Brown <lenb@kernel.org> wrote:
> From: Julian Anastasov <ja@ssi.bg>
>
>        commit 64b3db22c04586997ab4be46dd5a5b99f8a2d390 (2.6.39),
> "Remove use of unreliable FADT revision field" causes regression
> for old P4 systems because now cst_control and other fields are
> not reset to 0.
>
>        The effect is that acpi_processor_power_init will notice
> cst_control != 0 and a write to CST_CNT register is performed
> that should not happen. As result, the system oopses after the
> "No _CST, giving up" message, sometimes in acpi_ns_internalize_name,
> sometimes in acpi_ns_get_type, usually at random places. May be
> during migration to CPU 1 in acpi_processor_get_throttling.
>
>        Every one of these settings help to avoid this problem:
>  - acpi=off
>  - processor.nocst=1
>  - maxcpus=1
>
>        The fix is to update acpi_gbl_FADT.header.length after
> the original value is used to check for old revisions.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=42700
> https://bugzilla.redhat.com/show_bug.cgi?id=727865
>
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> Acked-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>

This one should go into the stable trees.  The bug it fixes causes a
number of machines to not boot with anything newer than 2.6.38.

josh
