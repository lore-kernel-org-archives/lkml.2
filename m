Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1COJcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 05:32:47 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24478 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1COJcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 05:32:45 -0400
Date: Tue, 15 Mar 2011 10:32:28 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (jdelvare-hwmon  tree related)
Message-ID: <20110315103228.30233acc@endymion.delvare>
In-Reply-To: <4D7F2609.3080508@redhat.com>
References: <20110315192428.ce74a177.sfr@canb.auug.org.au>
	<4D7F2609.3080508@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011 09:40:41 +0100, Hans de Goede wrote:
> Hi,
> 
> On 03/15/2011 09:24 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >
> > drivers/hwmon/sch5627.c: In function 'sch5627_read_virtual_reg':
> > drivers/hwmon/sch5627.c:179: error: implicit declaration of function 'msleep'
> >
> > Caused by commit 19803daeb145 ("hwmon: New driver for SMSC SCH5627").
> > See Rule 1 in Documentation/SubmitChecklist.
> >
> > I have reverted that commit for today.
> 
> The attached patch should fix this, Jean can you please add this to your
> tree? Note feel free to merge it into the initial patch adding the sch5627 driver
> if you prefer.

Thanks for the fix, I've merged it in the original patch (to preserve
bisectability) and pushed it for next linux-next.

Stephen, sorry for the inconvenience, both Hans and myself build-tested
the new code on an architecture where <linux/delay.h> gets included
implicitly, so we didn't notice it was missing.

-- 
Jean Delvare
