Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3AHP00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 10:26:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42107 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab3AHP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 10:26:25 -0500
Date: Tue, 8 Jan 2013 15:25:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Boris BREZILLON <linux-arm@overkiz.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Victor <linux@maxim.org.za>, linux-kernel@vger.kernel.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH v4 RESEND] pwm: atmel: add Timer Counter Block PWM
	driver
Message-ID: <20130108152555.GC3931@n2100.arm.linux.org.uk>
References: <1355994776-4764-1-git-send-email-linux-arm@overkiz.com> <20130108071023.GA2171@avionic-0098.adnet.avionic-design.de> <50EC3997.5050702@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50EC3997.5050702@overkiz.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 04:21:59PM +0100, Boris BREZILLON wrote:
> Do I have to break the error string so that the line does not exceed 80
> characters ?

No.

> Checkpath script does not complain about it, and the CodingStyle file
> specify that visible strings should not be broken...

Correct.

> Same question applies to this error, which I converted to a multi-line
> error in a previous patch version:
> 
> 		dev_err(chip->dev,
> 			"failed to configure period_ns:\n"
> 			"the other PWM device in this group is already\n"
> 			"configured with a different period_ns value\n");

Which is a bad idea.  It appears in log files as multiple lines, which
makes parsing the error for analysis difficult (eg, you may have a
log analyser which tells you how many times an error occurs - the
above would be treated as three separate errors.
