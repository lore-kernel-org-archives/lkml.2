Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2JATJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:09:00 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:1943 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204Ab2JATI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:08:59 -0400
Message-ID: <1349118537.1414.22.camel@x61.thuisdomein>
Subject: Re: [PATCH] regmap: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Oct 2012 21:08:57 +0200
In-Reply-To: <20121001113927.GJ4360@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
	 <20121001100321.GB4360@opensource.wolfsonmicro.com>
	 <1349086606.24442.13.camel@x61.thuisdomein>
	 <20121001101859.GC4360@opensource.wolfsonmicro.com>
	 <1349087577.24442.21.camel@x61.thuisdomein>
	 <20121001113927.GJ4360@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2012 19:08:57.0325 (UTC) FILETIME=[350401D0:01CDA008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 12:39 +0100, Mark Brown wrote:
> I assume this is a regression they've introduced in 4.7.

For what it's worth, GCC 4.6 apparently shows identical behavior.

The code that triggers this warning was (basically) introduced in commit
b8fb5ab156055b745254609f4635fcfd6b7dabc8 ("regmap: Support raw reads
from cached registers"). The first release shipping that commit was
v3.4. The log of a build of v3.4 using the oldest version of GCC (that
Fedora used to build v3.4) I could find also contains this warning [0].
They used gcc-4.6.3-2.fc16.x86_64 in that build [1].

Perhaps I'll stumble on some build logs of v3.4 for which earlier
versions of GCC were used. That might show whether or not earlier
releases of GCC also print a warning for this code.


Paul Bolle

[0] http://kojipkgs.fedoraproject.org/packages/kernel/3.4.2/1.fc16/data/logs/x86_64/build.log
[1] http://kojipkgs.fedoraproject.org/packages/kernel/3.4.2/1.fc16/data/logs/x86_64/root.log

