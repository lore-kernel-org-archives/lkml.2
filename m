Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab1IBJLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:11:17 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:33181 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab1IBJLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:11:12 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E609F9C.5020403@cam.ac.uk>
Date: Fri, 02 Sep 2011 10:19:24 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Stephen Warren <swarren@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Andrew Chew <achew@nvidia.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH V3 1/5] i2c: Add irq_gpio field to struct i2c_client,
 i2c_board_info.
References: <1314914676-28397-1-git-send-email-swarren@nvidia.com> <20110902085620.4ad918c4@endymion.delvare>
In-Reply-To: <20110902085620.4ad918c4@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/11 07:56, Jean Delvare wrote:
> Stephen,
> 
> Can you please fix your e-mail client / system / whatever so that your
> patch series are no longer sent duplicated?
> 
> On Thu,  1 Sep 2011 16:04:27 -0600, Stephen Warren wrote:
>> Some devices use a single pin as both an IRQ and a GPIO. In that case,
>> irq_gpio is the GPIO ID for that pin. Not all drivers use this feature.
>> Where they do, and the use of this feature is optional, and the system
>> wishes to disable this feature, this field must be explicitly set to a
>> defined invalid GPIO ID, such as -1.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>> ---
>> v3: Also add the field to i2c_board_info, and copy the field from
>>     i2c_board_info to i2c_client upon instantiation
> 
> I don't get the idea. The i2c core doesn't make any use of the field,
> and that field will only be used by a few drivers amongst the 420+
> i2c drivers in the tree. This looks like a waste of memory. What's wrong
> with including the new field in the private platform or arch data
> structure for drivers which need it?
Why not make it platform data for now and 'if' it becomes way more common
(probably won't) we can always propose adding as a general field at a later
date.


