Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab0D3RoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:44:13 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:36704 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933483Ab0D3Rnu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:43:50 -0400
MIME-Version: 1.0
In-Reply-To: <n2kfa686aa41004301035p7e15c017u7a1b98389cc1e466@mail.gmail.com>
References: <4BDAF376.4030005@in.ibm.com> <4BDB12FB.5060806@in.ibm.com> 
	<n2kfa686aa41004301035p7e15c017u7a1b98389cc1e466@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Apr 2010 11:43:22 -0600
X-Google-Sender-Auth: f88ab60bf9b0441a
Message-ID: <g2mfa686aa41004301043i138ffb2dmac5b641fa3d512c4@mail.gmail.com>
Subject: Re: -next Apr 30: OOPS during eHEA driver initialization
To: Sachin Sant <sachinp@in.ibm.com>
Cc: "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 11:35 AM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Fri, Apr 30, 2010 at 11:27 AM, Sachin Sant <sachinp@in.ibm.com> wrote:
>> Sachin Sant wrote:
>>>
>>> With today's next eHEA drivers fails to initialize.
>>
>> If i revert the following patch eHEA network interface is initialized
>> properly.
>>
>> commit cebfe0b6709abdab997c1a00499d67efa32ee1f0
>> drivercore: Add of_match_table to the common device drivers
>
> That is an easy one to fix.  I'll get it updated today and send you the result.

Let me know if this patch fixes it:

Cheers,
g.

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index ce957a4..693b0e6 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -201,6 +201,9 @@ static int ibmebus_create_devices(const struct
of_device_id *matches)

 int ibmebus_register_driver(struct of_platform_driver *drv)
 {
+	if (!drv->driver.of_match_table)
+		drv->driver.of_match_table = drv->match_table;
+
 	/* If the driver uses devices that ibmebus doesn't know, add them */
 	ibmebus_create_devices(drv->driver.of_match_table);



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
