Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab2JFAKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 20:10:01 -0400
Received: from xes-mad.com ([216.165.139.218]:45689 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab2JFAKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 20:10:00 -0400
X-Greylist: delayed 3262 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Oct 2012 20:09:59 EDT
Message-ID: <1349478922.23533.78.camel@petert>
Subject: Re: 3.6.0+ (GIT) -- lpc_ich: Resource conflict(s) found affecting
 gpio_ich
From: Peter Tyser <ptyser@xes-inc.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>
Date: Fri, 05 Oct 2012 18:15:22 -0500
In-Reply-To: <CAHFgRy975B0fPsBqRY7xW53egRpUxcLG=6DYQGawz+M4hTxWdg@mail.gmail.com>
References: <CAHFgRy975B0fPsBqRY7xW53egRpUxcLG=6DYQGawz+M4hTxWdg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miles,

On Thu, 2012-10-04 at 10:14 -0400, Miles Lane wrote:
> ACPI Warning: 0x0000000000000828-0x000000000000082f SystemIO conflicts
> with Region \PMIO 1 (20120711/utaddress-251)
> ACPI: If an ACPI driver is available for this device, you should use
> it instead of the native driver
> ACPI Warning: 0x0000000000000500-0x000000000000053f SystemIO conflicts
> with Region \GPIO 1 (20120711/utaddress-251)
> ACPI: If an ACPI driver is available for this device, you should use
> it instead of the native driver
> lpc_ich: Resource conflict(s) found affecting gpio_ich

Jean Delvare submitted a patch which may allow you to use the GPIO pins
in banks not claimed by the BIOS:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=4f600ada70beeb1dfe08e11e871bf31015aa0a3d

This patch is not in 3.6, but will be included in 3.7.

You could also try adding "acpi_enforce_resources=lax" or
"acpi_enforce_resources=no" to your kernel parameters to disable the
ACPI conflict checking.  Note this could have other unintended
consequences.

Best,
Peter

