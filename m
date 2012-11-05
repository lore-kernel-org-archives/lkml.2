Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2KETmq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:42:46 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:50169 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab2KETmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:42:45 -0500
Message-ID: <509816A8.70005@ahsoftware.de>
Date: Mon, 05 Nov 2012 20:42:32 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
Subject: connector and netlink_broadcast (semop failed for cookie ...)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've recently enabled CONFIG_CONNECTOR in kernel 3.6.6 and now I've got 
the message "semop failed for cookie ..." when using cryptsetup (I've 
never got that error before).

A short search revealed the following discussion about ignoring errors 
from netlink_broadcast_filtered(): https://lkml.org/lkml/2011/8/19/60

connector doesn't use netlink_broadcast_filtered() directly but it 
returns netlink_broadcast() in cn_netlink_send() while 
netlink_broadcast() just is a wrapper around netlink_broadcast_filtered().

Could it be the case that cn_netlink_send() has to ignore the same 
return codes as done in kobject_uevent_env()? Or maybe the users of 
cn_netlink_send() have to ignore them?

Regards,

Alexander
