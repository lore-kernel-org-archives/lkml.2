Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1IZPsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 11:48:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44303 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1IZPsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 11:48:40 -0400
MIME-Version: 1.0
In-Reply-To: <20110926152634.GN2946@opensource.wolfsonmicro.com>
References: <20110922184614.25419.84606.stgit@ponder> <20110926141643.GK2946@opensource.wolfsonmicro.com>
 <20110926151210.GO22455@n2100.arm.linux.org.uk> <20110926152634.GN2946@opensource.wolfsonmicro.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 26 Sep 2011 09:48:19 -0600
X-Google-Sender-Auth: gcIsO7pfJYMBa1pRsbf2AZzmW_I
Message-ID: <CACxGe6swdnhk_GCAv3siSx4kxNQXmCLDbwBFjsX5VPNfCBc2Mg@mail.gmail.com>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 9:26 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Sep 26, 2011 at 04:12:10PM +0100, Russell King - ARM Linux wrote:
>> On Mon, Sep 26, 2011 at 03:16:43PM +0100, Mark Brown wrote:
>
>> > used but it's not a blocker for anything.  Devices doing this would need
>> > some way to figure out if they should -EBUSY or fail otherwise.
>
>> Just to avoid confusion - ITYM -EAGAIN there.  -EBUSY is already used
>> by drivers to mean "someone else claimed a resource I need" be it the
>> IO region or an IRQ resource...
>
> Yes, I do - sorry.

Actually, in the next iteration, I'm thinking it would be a good idea
to create a new #define to only be used by probe deferral.  I want it
to be easy to find all the drivers that are using this mechanism
without needing to filter all the unrelated hits.  However, this is a
kernel-only thing so it is probably not appropriate to add it to
include/asm-generic/errno.h.  I could use some guidance/advice as to
the best way to handle this.

g.
