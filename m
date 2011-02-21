Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1BUX2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 18:28:09 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44648 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab1BUX2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 18:28:07 -0500
Message-ID: <4D62F502.9040506@linux.vnet.ibm.com>
Date: Mon, 21 Feb 2011 15:28:02 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>
Subject: [BUG ?] checkpatch.pl rejects as error something I think it ought
 to be allow
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a piece of code where I have two constants defined as follows:

	static const unsigned long polling_interval_sec = 1;
	static const unsigned long polling_interval_ns = 0;

Now, it's clear to me that I want these two values to have the keywords 
const and static.  I could use a #define here, but const static seemed 
cleaner to me.

When I run checkpatch.pl across this code, I get this error:

ERROR: do not initialise statics to 0 or NULL.

I think the problem here is that another case is needed for "static 
const" that does allow 0.

What do you think?

Thanks for your consideration,

- Corey
