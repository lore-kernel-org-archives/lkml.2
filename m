Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1CKJuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:50:44 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51195 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1CKJui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:50:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:content-type:content-transfer-encoding;
        b=KcFiA7llsxUsn9z0YVfYpMfabvRHMbtQF4YGUA3nMWGMx7qbDadb/P7WxGakdhrVEe
         tjnNq/zsYXEHo7YWjBf+KPOuODo9Er9xT5qIaKKg5SlrF5vegwuioQvnHhPmfenLAR6w
         Md6qHDuH/sWoSyTsGmG/zEpqgu/iQKDybwrIQ=
Message-ID: <4D79F068.2080009@linaro.org>
Date: Fri, 11 Mar 2011 09:50:32 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Linux USB list <linux-usb@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: RFC: Platform data for onboard USB assets
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

platform_data is a well established way in Linux to pass configuration 
data up to on-board assets from a machine file like mach-xyz.c.  It's 
also supported to pass platform_data up to devices that are probed 
asynchronously from busses like i2c as well, which is very handy.

However AFAIK it's not possible to bind platform_data to probed USB 
devices as it stands.

There are now boards which have on-board USB assets, for example OMAP4 
Panda which has a USB <-> Ethernet bridge wired up permanently.  It'd be 
convenient to also be able to pass optional platform_data to these 
devices when they are asynchronously probed.

So what's the feeling about a new api to register an array of 
platform_data pointers bound to static "devpath" names in the machine file?

When a usb device is instantiated, it can check through this array if it 
exists, matching on devname, and attach the platform_data to the 
underlying probed usb device's dev->platform_data, which it seems is 
currently unused.

The particular use that suggested this is on Panda, it would be ideal to 
be able to set a flag in the usb device's platform data that forces it 
to be named eth%d since it's a hardwired asset on the board with an RJ45 
socket.

Comments, implementation suggestions, enquiries as to my level of crack 
consumption etc welcomed ^^

-Andy
