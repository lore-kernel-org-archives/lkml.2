Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914Ab0J0K7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:59:50 -0400
Received: from smtp.nokia.com ([147.243.1.47]:42657 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760900Ab0J0K7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:59:46 -0400
Subject: sysfs and power management
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: gregkh@suse.de, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Wed, 27 Oct 2010 13:59:03 +0300
Message-Id: <1288177143.12206.22.camel@4fid08082>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have recently sent couple of sensor drivers to kernel.
Interface is purely sysfs based. The hard part is to get
power management to work reasonable way.

With /dev/* interface power management is quite easy to do since
driver gets clear open and release calls. With sysfs, there is only
read / write methods available.
My solution has been separate sysfs entry which controls operating
state. However, there are some problems with that.
In case of boolean type enable / disable control, there must be
only one userspace component which decides sensor state.
In case of counting type of control, there is a change that
sensor is permanently left on if the userspace component crashes.
This would lead to unbalanced enable / disable count.

If the sensor functionality is based on interrupts (like threshold
interrupt), it may take long time before there is any activity.
In this kind of case timeout from the previous sysfs access doesn't make
much sense. 
I started to wonder if it makes sense to enhance sysfs so that it
optionally prodives open / close call backs. Internally sysfs has some 
bookkeeping about the refcount but this is not visible to the driver.
Of course majority of the sysfs users doesn't need that at all
and for them this is just overhead. 

Is it out of the question to provide call back to driver when 
some sysfs entry is opened (first time) and when refcnt goes back
to 0?

Regards,
Samu


