Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0I2Oxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:53:32 -0400
Received: from mail.lixom.net ([70.86.134.90]:43065 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab0I2Oxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:53:31 -0400
Date: Wed, 29 Sep 2010 09:53:30 -0500
From: Olof Johansson <olof@lixom.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
Message-ID: <20100929145330.GA9351@lixom.net>
References: <20100928211246.GA20941@lixom.net> <20100929093403.7db92388@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929093403.7db92388@endymion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:34:03AM +0200, Jean Delvare wrote:
> Hi Olaf,
> 
> On Tue, 28 Sep 2010 16:12:46 -0500, Olof Johansson wrote:
> > I've found this quite useful since it allows dmidecode to run without
> > root privileges using --from-dump to read this file instead
> 
> This is a bad idea. We do NOT want every user to have access to all the
> DMI information. There is sensitive information in there (serial
> numbers and UUIDs, and possibly even more sensitive data in
> OEM-specific records.) If you look in /sys/class/dmi/id/, you'll see
> that files board_serial, chassis_serial, product_serial and
> product_uuid are only readable by root exactly for this reason.

> So this is a NACK from me, sorry.

So how about a change to mode 0400 on the debugfs file then? It's
still better than having a userspace tool dig around /dev/mem for the
information.


-Olof
