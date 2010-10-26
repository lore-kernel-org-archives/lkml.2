Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab0JZJMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:12:34 -0400
Received: from t1817.greatnet.de ([83.133.124.152]:36540 "EHLO
	t1817.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0JZJMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:12:33 -0400
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 05:12:33 EDT
From: Matthias Dunda <user254@t1817.greatnet.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: Reading temperature from another Kernel modules
Date: Tue, 26 Oct 2010 11:01:56 +0200
Message-Id: <007FBA04-E52D-497B-A43B-738F15E33558@t1817.greatnet.de>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1081)
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everybody,

I need to read out the current system temperature from inside my custom kernel module.

My system works with the jc42.c driver and I can read the temperature perfectly via the proc filesystem in user space.

How do I query the temperature from another kernel driver?

First of all I added a new function and exported the symbol

int jc42_get_temperature()
{
   int temp;
   // TODO get the correct temp
   temp = jc42_read_value(my_local_client, JC42_REG_TEMP);
   return temp;
}
EXPORT_SYMBOL(jc42_get_temperature);

BUT: how do I get the temp? Most of the internal functions require a struct device or a struct i2c_client, which - I assume - are perfectly provided by the kernel when going the way over the proc file system.

I tried to statically save such a struct during the probing process (this is the above my_local_client), but this works neither. When I use the saved struct to call jc42_read_value, I always get a temperature value which is not correct at all.

Kernel is 2.6.29.6-rt24 (yes, jc42 is originally not included there - we ported it from a newer kernel release.)

Thanks for any help!
Matthias


