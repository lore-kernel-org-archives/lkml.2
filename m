Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0LHH4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:56:11 -0500
Received: from webbox687.server-home.net ([195.149.74.151]:39616 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab0LHH4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:56:09 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Subject: detached sleepable task during initcall
Date: Wed, 8 Dec 2010 08:55:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-gentoo-r12; KDE/4.4.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201012080856.06972.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

we need to run a platform dependant function changing GPIOs which need a 
specific time between those changes. Actually it is the platform set_power 
function used by platform_lcd_probe. This itself is no problem. But the 
currently used msleeps on about 250ms summarized is really much while the 
system idles.
We'd like to avoid idle during that msleeps. So, we used a work_queue in that 
set_power function. But unforturnatly do_initcalls calls flush_scheduled_work 
at the end. So the system will still idle until this work_queue has finished.
What can we use to call the set_power function asynchronously and sleepable 
while not waiting during system startup on this function to be finished? The 
set_power just enabled the lcd power and nothing need to wait on that.

Regards,
Alexander
