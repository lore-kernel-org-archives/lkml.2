Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab2C1T7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 15:59:07 -0400
Received: from imr3.ericy.com ([198.24.6.13]:56576 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758510Ab2C1T7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 15:59:05 -0400
Message-ID: <1332964559.21301.144.camel@groeck-laptop>
Subject: Re: [PATCH] acpi_power_meter: fix lockdep spew due to non-static
 lock class
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Kyle McMartin <kyle@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "djwong@us.ibm.com" <djwong@us.ibm.com>
Date: Wed, 28 Mar 2012 12:55:59 -0700
In-Reply-To: <20120328191147.GK25886@redacted.bos.redhat.com>
References: <20120328191147.GK25886@redacted.bos.redhat.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 15:11 -0400, Kyle McMartin wrote:
> Similar to a30dcb4f which fixed asus_atk0110.ko, I recently received a
> bug report from someone hitting the same issue in acpi_power_meter.
> 
> [   13.963168] power_meter ACPI000D:00: Found ACPI power meter.
> [   13.963900] BUG: key ffff8802161f3920 not in .data!
> [   13.963904] ------------[ cut here ]------------
> [   13.963915] WARNING: at kernel/lockdep.c:2986
> 	lockdep_init_map+0x52f/0x560()
> 
> So let's fix that up for them by statically declaring the
> lockdep_class_key.
> 
> Signed-off-by: Kyle McMartin <kyle@redhat.com>
> 
Applied.

Thanks,
Guenter


