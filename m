Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2AaKlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:41:25 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60620 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab2AaKlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:41:23 -0500
Message-ID: <4F27C54F.1010107@suse.cz>
Date: Tue, 31 Jan 2012 11:41:19 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120124 Thunderbird/10.0
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>
Subject: network regression: cannot rename netdev twice
References: <4F27120A.4040106@suse.cz> <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
In-Reply-To: <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 11:52 PM, Kay Sievers wrote:
> 2012/1/30 Jiri Slaby <jslaby@suse.cz>:
>> I cannot boot properly with this commit:
>> commit 524b6c5b39b931311dfe5a2f5abae2f5c9731676
>> Author: Eric W. Biederman <ebiederm@xmission.com>
>> Date:   Sun Dec 18 20:09:31 2011 -0800
>>
>>    sysfs: Kill nlink counting.
>>
>>
>> 1) network systemd rule doesn't start network
> 
> What does that mean? What's a network systemd rule?

Oh, perhaps you call it a service file, not rule file?

Anyway this is a different bug. Revert of the patch above does not help.

The bug lays in the network layer. udev is unable to perform persistent
eth naming:
# ip link set eth0 name eth1    -- this one is OK
# ip link set eth1 name eth0
RTNETLINK answers: No such file or directory

thanks,
-- 
js
suse labs
